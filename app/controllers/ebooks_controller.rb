class EbooksController < ApplicationController
  def index
    @ebooks = Book.where("root != ''")

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @ebooks }
    end
  end

  def new
    @ebook = Book.new
    puts "ebook new....."
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ebook }
    end

  end

  def edit
    @book = Book.find(params[:id])
  end
end
