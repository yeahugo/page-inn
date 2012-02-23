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
      render :nothing => true, :status => "600" and return false
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
        render :nothing => true,:status => "200"
      else
        render :nothing => true, :status => "500"
      end

    else

    respond_to do |format|
      if @book.save
        if iOS_user_agent?
          render :nothing => true
        end
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        if iOS_user_agent?
          render :status => "400"
        end
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
    end
  end

  #在web端借书
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

  #用手机借书
  def borrow

    #有对应udid的用户
    if User.where("udid = ?",params[:udid]).count >0
      userid = User.where("udid = ?",params[:udid]).first.id

    #没有对应udid，如果已经登陆的情况下，把用户的udid号和用户账号绑定
    elsif user_signed_in?
        udid = params[:udid]
        userid = current_user.id
        User.update(current_user.id,:udid =>udid)
    else
      render :nothing => true,:status => "410" and return false
      return false
    end

    if Book.where("isbn = ?",params[:isbn]).count == 0
      render :nothing => true, :status => "412" and return false
    end
    book = Book.where("isbn = ?",params[:isbn]).first

    bookid = book.id
    book_status = book.status

    if book_status != 0
      render :nothing => true, :status => "411" and return false
    end

    if userid == nil then userid = User.where("udid = ?",params[:udid]).first.id end

    Book.update(bookid, :status => userid)

    bookUsership = BookUsership.create(:user_id => userid,:book_id => bookid , :is_lend =>1)

    if bookUsership.save
     render :nothing => true, :status => "211" and return false
    end
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
