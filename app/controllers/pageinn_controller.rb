class PageinnController < ApplicationController
  def index
    redirect_to books_url
  end

  def login
    redirect_to  user_session_url
  end
end
