class UsersController < ApplicationController
  before_filter :check_login, :only => [:profile]

  def biz
    if logged_in?
      redirect_to root_path
      return
    end
    if params[:user]
      logout_keeping_session!
      @user = User.authenticate(params[:user][:email], params[:user][:password])
      if @user        
        session[@user.email] = nil
        self.current_user = @user
        new_cookie_flag = (params[:remember_me] == "1")
        handle_remember_cookie! new_cookie_flag
        redirect_back_or_default('/')
        flash[:notice] = nil
      else
        @new_user = User.find_by_email(params[:user][:email])
        if @new_user          
          @message = "User/Password does not match."
        else
          @user = User.new(params[:user])

          if @user.valid?
            @user.save
            self.current_user = @user
            new_cookie_flag = (params[:remember_me] == "1")
            handle_remember_cookie! new_cookie_flag
            redirect_back_or_default('/')
            flash[:notice] = nil
            return
          else
            @user.password = nil
          end
        end
        flash[:error] = "Please enter valid information"
      end
    end
  end

   def profile
    @profile = current_user.profile if current_user.profile
    if request.post?
      @profile = Profile.new(params[:profile])
      if @profile.valid?
        current_user.profile.destroy if current_user.profile
        @profile.user = current_user
        @profile.save
        flash[:notice] = "Profile saved successfully"
        redirect_to root_path
      else
        flash[:error] = "Please enter valid information."
      end
    end
  end

   def destroy
    logout_killing_session!
    # session[:user_id] = nil
    # session[:fb_user] = nil
    reset_session
    flash[:notice] = "You have ended your session."
    redirect_back_or_default('/')
  end

  def fb_login
    if biz_logged_in?
      flash[:error] = "You are already login with business user."
      redirect_to root_path
      return
    end

    omniauth = request.env["omniauth.auth"]

    user = User.find_by_fb_uid(omniauth['uid']) || User.new(:fb_uid => omniauth['uid'])
    # render :text => omniauth.inspect and return false
    user.name = omniauth["info"]['name']
    user.fb_login = true
    user.email = omniauth["info"]['email']
    unless user.save
      flash[:error] = user.errors.first
    end

    session[:fb_user] = user.id

    # redirect_to root_path
    redirect_to session[:location] || root_path
  rescue
    redirect_to root_path
  end

end
