class PagebooksController < ApplicationController
  # GET /pagebooks
  # GET /pagebooks.json
  def index
    @pagebooks = Pagebook.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pagebooks }
    end
  end

  # GET /pagebooks/1
  # GET /pagebooks/1.json
  def show
    @pagebook = Pagebook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pagebook }
    end
  end

  def lend
    @pagebook = Pagebook.find(params[:id])

    bookid = @pagebook.book_id;
    @pagebook_to_user = PagebookUsership.new()
    @pagebook_to_user.save
  end

  # GET /pagebooks/new
  # GET /pagebooks/new.json
  def new
    @pagebook = Pagebook.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pagebook }
    end
  end

  # GET /pagebooks/1/edit
  def edit
    @pagebook = Pagebook.find(params[:id])
  end

  # POST /pagebooks
  # POST /pagebooks.json
  def create
    @pagebook = Pagebook.new(params[:pagebook])

    respond_to do |format|
      if @pagebook.save
        format.html { redirect_to @pagebook, notice: 'Pagebook was successfully created.' }
        format.json { render json: @pagebook, status: :created, location: @pagebook }
      else
        format.html { render action: "new" }
        format.json { render json: @pagebook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pagebooks/1
  # PUT /pagebooks/1.json
  def update
    @pagebook = Pagebook.find(params[:id])

    respond_to do |format|
      if @pagebook.update_attributes(params[:pagebook])
        format.html { redirect_to @pagebook, notice: 'Pagebook was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pagebook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pagebooks/1
  # DELETE /pagebooks/1.json
  def destroy
    @pagebook = Pagebook.find(params[:id])
    @pagebook.destroy

    respond_to do |format|
      format.html { redirect_to pagebooks_url }
      format.json { head :no_content }
    end
  end
end
