class PagebookUsershipsController < ApplicationController
  # GET /pagebook_userships
  # GET /pagebook_userships.json
  def index
    @pagebook_userships = PagebookUsership.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pagebook_userships }
    end
  end

  # GET /pagebook_userships/1
  # GET /pagebook_userships/1.json
  def show
    @pagebook_usership = PagebookUsership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pagebook_usership }
    end
  end

  # GET /pagebook_userships/new
  # GET /pagebook_userships/new.json
  def new
    @pagebook_usership = PagebookUsership.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pagebook_usership }
    end
  end

  # GET /pagebook_userships/1/edit
  def edit
    @pagebook_usership = PagebookUsership.find(params[:id])
  end

  # POST /pagebook_userships
  # POST /pagebook_userships.json
  def create
    @pagebook_usership = PagebookUsership.new(params[:pagebook_usership])

    respond_to do |format|
      if @pagebook_usership.save
        format.html { redirect_to @pagebook_usership, notice: 'Pagebook usership was successfully created.' }
        format.json { render json: @pagebook_usership, status: :created, location: @pagebook_usership }
      else
        format.html { render action: "new" }
        format.json { render json: @pagebook_usership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pagebook_userships/1
  # PUT /pagebook_userships/1.json
  def update
    @pagebook_usership = PagebookUsership.find(params[:id])

    respond_to do |format|
      if @pagebook_usership.update_attributes(params[:pagebook_usership])
        format.html { redirect_to @pagebook_usership, notice: 'Pagebook usership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pagebook_usership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pagebook_userships/1
  # DELETE /pagebook_userships/1.json
  def destroy
    @pagebook_usership = PagebookUsership.find(params[:id])
    @pagebook_usership.destroy

    respond_to do |format|
      format.html { redirect_to pagebook_userships_url }
      format.json { head :no_content }
    end
  end
end
