# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'open-uri'
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem # logged_in? and current_user
  include ApplicationHelper
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password


  def store_location
    # session[:location] = request.referer
  end

  def check_login
    if logged_in? # and session[:page_access] == true
      flash.discard
    else
      flash[:notice] = "Please login."
      session[:location] = request.referer
      redirect_to login_path
    end
  end
  def check_biz_login
    if biz_logged_in? # and session[:page_access] == true
      flash.discard
    else
      flash[:notice] = "Please login"
      redirect_to root_path
    end
  end

  def check_fb_login
    unless fb_logged_in? 
      flash[:notice] = "Please login"
      session[:location] = request.referer
      redirect_to login_path
    end
  end

   
end
