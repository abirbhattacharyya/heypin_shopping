class ProductsController < ApplicationController
  before_filter :check_biz_login,:only => [:product_catalog]
  before_filter :check_fb_login,:only => [:set_like,:purchase,:cart,:checkout,:payment,:comment,:remove_cart]

   def product_catalog
    if request.post?
      @product = Product.new(params[:product])
      @product.user = current_user
      @product.price = params[:product][:price].gsub(/\D+/, "")
      if check_for_image_upload and @product.valid?
        @product.save
        1.upto(MAX_IMAGES).each do |i|
          if !params["image_#{i}"].blank? || !params["image_remote_url_#{i}"].blank?        
            product_image = ProductImage.new
            product_image.image = params["image_#{i}"]
            product_image.image_remote_url = params["image_remote_url_#{i}"]
            product_image.product_id = @product.id
            product_image.save
          end
        end  

        
        flash[:notice] = "Product saved successfully"
        if params[:submit_button].strip.downcase.eql? "finish"
          redirect_to product_path(@product)
        else
          @product = nil  
        end
      else
        flash[:error] = @product.errors.first[1]
      end
    end
  end

  def purchase
    purchse_type = params[:purchase_type].to_i
    product = Product.find_by_id(params[:product_id])
    session[:cart] ||= [] 
    session[:cart].push(product.id) if product and !session[:cart].include?(product.id)
    case purchse_type
      when Payment::PURCHASE_TYPE[:add_to_cart]                
        redirect_to product_path(product)
      when Payment::PURCHASE_TYPE[:buy]
        redirect_to cart_products_path
    end
    # render :text => params.inspect
  end


  def remove_cart
    product = params[:id]
    session[:cart] ||= []
    session[:cart].delete(product.to_i)
    redirect_to cart_products_path
  end

  def show
    @product = Product.find(params[:id])
    redirect_to root_path if @product.nil?
  rescue  
    redirect_to root_path
  end

  def set_like
    @product = Product.find(params[:id])
    product_like = ProductLike.new(:product_id => @product.id)
    product_like.user = fb_current_user
    product_like.save
  end

  def cart
  end

  def checkout
    @payment = Payment.new
    @payment.cc_expiry_year = Date.today.year
    @month  = Date.today.month
  end

  def payment 
    all_products = get_cart_products

    redirect_to root_path and return if all_products.empty?

    @payment = Payment.new(params[:payment])
    @payment.cc_expiry_month = (@payment.cc_expiry_year == Date.today.year) ? @payment.cc_expiry_m1 : @payment.cc_expiry_m2
    @month = @payment.cc_expiry_month
    
    @payment.user_id = fb_current_user.id
    @payment.prodcut_id = all_products.map(&:id).join(",")
    @payment.price = all_products.map(&:price).sum

    if @payment.valid? and @payment.validate_card
        success,msg = @payment.purchase(@payment.price)
        if success
          session[:cart] = nil
          flash[:notice] = "Payment saved."
          redirect_to root_path 
        else
          flash[:error] = msg
          render :action => :checkout
        end
    else   
      field_name = @payment.errors.first[0]
      flash[:error] = "Please enter valid #{field_name.to_s.titleize}"
      render :action => :checkout 
    end    
  end

  def comment
    @product = Product.find(params[:id])
    if request.post?
      comment = params[:comment]
      @comment = fb_current_user.comments.new(:comment => comment.strip)
      @comment.product_id = @product.id
      if @comment.valid?
        @comment.save
        redirect_to root_path, :notice => "Comment added successfully."
      else
        flash[:notice] = @comment.errors.full_messages.first
      end
    end
  rescue
    redirect_to root_path 
  end

  private

  def check_for_image_upload
    valid_rec = false
    1.upto(MAX_IMAGES).each do |i|      
      if !params["image_#{i}"].blank? || !params["image_remote_url_#{i}"].blank?        
        valid_rec = true
      end            
      break if valid_rec == true
    end
    @product.errors.add(:image,"Image can't be blank")  unless valid_rec
    return valid_rec
  end
end
