class ApplicationController < ActionController::Base
  protect_from_forgery

  def iOS_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone)/]
  end

  def after_sign_in_path_for(resource)
    path = ''
    puts "qweqqweqeqwe"+request.env["HTTP_USER_AGENT"]
    if iOS_user_agent?
      #render :nothing => false, :status => "222" and return false
    else
      path = super
    end
    puts path
    path
  end
end
