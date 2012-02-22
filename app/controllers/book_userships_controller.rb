class BookUsershipsController < ApplicationController
  # GET /book_userships
  # GET /book_userships.json
  def index
    @book_userships = BookUsership.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @book_userships }
    end
  end

  # GET /book_userships/1
  # GET /book_userships/1.json
  def show
    @book_usership = BookUsership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book_usership }
    end
  end

  # GET /book_userships/new
  # GET /book_userships/new.json
  def new
    @book_usership = BookUsership.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book_usership }
    end
  end

  # GET /book_userships/1/edit
  def edit
    @book_usership = BookUsership.find(params[:id])
  end

  # POST /book_userships
  # POST /book_userships.json
  def create
    @book_usership = BookUsership.new(params[:book_usership])

    respond_to do |format|
      if @book_usership.save
        format.html { redirect_to @book_usership, notice: 'Book usership was successfully created.' }
        format.json { render json: @book_usership, status: :created, location: @book_usership }
      else
        format.html { render action: "new" }
        format.json { render json: @book_usership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /book_userships/1
  # PUT /book_userships/1.json
  def update
    @book_usership = BookUsership.find(params[:id])

    respond_to do |format|
      if @book_usership.update_attributes(params[:book_usership])
        format.html { redirect_to @book_usership, notice: 'Book usership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book_usership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_userships/1
  # DELETE /book_userships/1.json
  def destroy
    @book_usership = BookUsership.find(params[:id])
    @book_usership.destroy

    respond_to do |format|
      format.html { redirect_to book_userships_url }
      format.json { head :no_content }
    end
  end
end
