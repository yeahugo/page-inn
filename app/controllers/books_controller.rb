require 'net/http'
require "uri"
require "rexml/document"
include REXML

class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    @books = Book.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show

    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  def iOS_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(pagePhone)/]
  end

  def isbn
    isbn = params[:isbnid]

    isbnArray = Book.select("isbn")

    isbnArray.each do |e|
      if e["isbn"] == isbn
      render 'welcome/index', :status => "600" and return false
      end
    end

    str = "http://api.douban.com/book/subject/isbn/"+isbn.to_s
    url = URI.parse(str)

    response = Net::HTTP.get_response(url)

    doc = Document.new response.body.to_s

    @book

    title  = doc.root.elements["title"].text
    author = doc.root.elements["author"].elements["name"].text

    if title
      @book = Book.new(:title => title, :author => author, :isbn => isbn, :root =>'', :status => '0')
    end

    if iOS_user_agent?
      if @book && @book.save
        render 'welcome/index',:status => "200"
      else
        render 'welcome/index', :status => "500"
      end

    else

    respond_to do |format|
      if @book.save
        if iOS_user_agent?
          render 'welcome/index'
          render :text => "OK"
        end
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        if iOS_user_agent?
          render :status => 400
        end
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
    end
  end

  def lend
    @book = Book.find(params[:id])

    bookid = @book.id
    Book.update(bookid, :status => current_user.id)

    bookUsership = BookUsership.create(:user_id => current_user.id,:book_id => bookid , :is_lend =>1)
    bookUsership.save
    redirect_to books_path
  end

  def return
    @book = Book.find(params[:id])

    bookid = @book.id
    Book.update(bookid, :status => '0')

    bookUsership = BookUsership.create(:user_id => current_user.id,:book_id => bookid , :is_lend =>0)
    bookUsership.save
    redirect_to books_path
  end


  # POST /books
  # POST /books.json
  def create
    @book = Book.new(params[:book])

    puts params[:book].inspect

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end
end
