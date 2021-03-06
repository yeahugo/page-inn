require 'net/http'
require "uri"
require "rexml/document"
require "open-uri"

include REXML

class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    @tagsArray = Tag.instance.toptags

    @books = Book.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @books }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show

    @book = Book.find(params[:id])

    reBooks = BookRecommender.instance.recommend(@book.id)

    bookidArray = reBooks.sort_by{|e| -e.similarity.to_f}.first(5).map do |book|
      book.item_id
    end

    if bookidArray.first !=nil
      @recommendBooks = Book.find(bookidArray)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @book }
    end
  end

  def tag
    #@tag = params[:tagnum].to_s
    @books = Book.where("tags LIKE '%#{params[:tagnum]}%'")
    puts @books.inspect
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
    unless Book.where("isbn = ?",isbn).first.nil?
      render :nothing => true, :status => "600" and return false
    end

    str = "http://api.douban.com/book/subject/isbn/"+isbn.to_s

    url = URI.parse(str)
    response = Net::HTTP.get_response(url)
    doc = Document.new response.body.to_s

    if doc.root.nil?
      render :nothing => true, :status => "412" and return false
    end

    title  = doc.root.elements["title"].text
    unless author = doc.root.elements["author"].nil? then
      author = doc.root.elements["author"].elements["name"].text
    end

    imageURL = doc.root.elements["link"].next_element.next_element.attributes["href"]

    tags = String.new
    doc.root.elements.each('db:tag') {|e|tags +=e.attributes["name"] + ' '}

    unless doc.root.elements["summary"].nil? then
      summary = doc.root.elements["summary"].text
    end

    index = imageURL=~/spic/
    imageURL[index,1] = "l"

    data = open(imageURL){|f|f.read}
    open("public/assets/books/"+isbn+".jpg","wb"){|f|f.write(data)}

    @book = Book.new(:title => title, :author => author, :isbn => isbn, :path =>'', :status => '0',:tags => tags,:summary => summary)

    if iOS_user_agent?
      if @book.save
        render :nothing => true,:status => "200"
      else
        render :nothing => true, :status => "500"
      end

    else

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

  #用手机udid还书
  def returnbook
    if params[:udid]
      udid = params[:udid]

      unless user = User.where("udid = ?",udid).first
        render :nothing => true, :status => 413 and  return false
      end

      unless book = Book.where("isbn = ?",params[:isbn]).first
        render :nothing =>true, :status => 412 and return false
      end
      unless book = Book.where("isbn = ? and status = ?",params[:isbn],user.id).first
        render :nothing =>true, :status =>414  and return false
      end

      Book.update(book, :status => "0")
      bookUsership = BookUsership.create(:user_id => user.id,:book_id => book.id , :is_lend =>0)
      if bookUsership.save
        render :nothing =>true, :status => 212 and return false
      end

    else
    book = Book.find(params[:id])

    Book.update(book.id, :status => '0')

    bookUsership = BookUsership.create(:user_id => current_user.id,:book_id => book.id , :is_lend =>0)
    bookUsership.save
    redirect_to books_path
    end
  end

  #用手机udid借书
  def borrow

    #有对应udid的用户
    if user = User.where("udid = ?",params[:udid]).first
      userid = user.id

    #没有对应udid，如果已经登陆的情况下，把用户的udid号和用户账号绑定
    elsif user_signed_in?
        udid = params[:udid]
        userid = current_user.id
        User.update(current_user.id,:udid =>udid)
    else
      render :nothing => true,:status => "410" and return false
      return false
    end

    unless book = Book.where("isbn = ?",params[:isbn]).first
      render :nothing => true, :status => "412" and return false
    end

    if book.status != 0
      render :nothing => true, :status => "411" and return false
    end

    Book.update(book.id, :status => userid)

    bookUsership = BookUsership.create(:user_id => userid,:book_id => book.id , :is_lend =>1)

    if bookUsership.save
     render :nothing => true, :status => "211" and return false
    end
  end

  #用二维码借书
  def borrowmatrix
    unless book = Book.where("isbn = ?",params[:isbn]).first
      render :nothing => true, :status => "412" and return false
    end

    if book.status != 0
      render :nothing => true, :status => "411" and return false
    end

    Book.update(book.id, :status => session[:current_user_id])

    bookUsership = BookUsership.create(:user_id => session[:current_user_id],:book_id => book.id , :is_lend =>1)

    if bookUsership.save
      render :nothing => true, :status => "211" and return false
    end

  end

  #用二维码还书
  def returnmatrix
    unless book = Book.where("isbn = ?",params[:isbn]).first
      render :nothing =>true, :status => 412  and return false
    end
    unless book = Book.where("isbn = ? and status = ?",params[:isbn],session[:current_user_id]).first
      render :nothing =>true, :status =>414 and return false
    end

    Book.update(book, :status => "0")
    bookUsership = BookUsership.create(:user_id => session[:current_user_id],:book_id => book.id , :is_lend =>0)
    if bookUsership.save
      render :nothing =>true, :status => 212 and return false
    end

  end

  # POST /books
  # POST /books.json
  def create
    puts params[:book].inspect

    unless params[:book][:root].nil?
      directory = "/Users/ios_umeng/Public/eBook/"
      puts params.inspect
      path = File.join(directory, params[:book][:root].original_filename)

      File.open(path, "wb") { |f| f.write(params[:book]['root'].read) }

      params[:book][:root] = path
      @book = Book.new(params[:book])
    else
      @book = Book.new(params[:book])
    end
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
