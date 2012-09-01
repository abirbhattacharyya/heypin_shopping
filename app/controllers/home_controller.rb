class HomeController < ApplicationController
  before_filter :store_location,:only => [:login]
  def index
    if biz_logged_in?
      if current_user.profile.nil?
        render :template => "users/profile"
        return 
      elsif current_user.products.size <= 0
        render :template => "products/product_catalog"
      else
        @notifications = [["profile", current_user.profile.created_at], ["prices", current_user.products.last.created_at]]
        @notifications.sort!{|n1, n2| n2[1] <=> n1[1]}
        render :template => "home/notifications"
      end
    end
    @products = Product.includes([:product_images,:comments,:product_likes])    
    @like_products  = fb_current_user ? fb_current_user.product_likes.map(&:product_id) : []
  end


  def login
    if logged_in?
      puts "-"*50
      puts "Location: #{session[:location]}    "
      redirect_to session[:location] || root_path
    end
  end

end
