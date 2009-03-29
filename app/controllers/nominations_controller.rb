class NominationsController < ApplicationController
  before_filter :verify_access
  before_filter :add_parties, :except => ["index","show"]


  # GET /nominations
  # GET /nominations.xml
  def index
    @nominations = Nomination.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nominations }
    end
  end

  # GET /nominations/1
  # GET /nominations/1.xml
  def show
    @nomination = Nomination.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nomination }
    end
  end

  # GET /nominations/new
  # GET /nominations/new.xml
  def new
    @nomination = Nomination.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nomination }
    end
  end

  # GET /nominations/1/edit
  def edit
    @nomination = Nomination.find(params[:id])
  end

  # POST /nominations
  # POST /nominations.xml
  def create
    @nomination = Nomination.new(params[:nomination])

    respond_to do |format|
      if @nomination.save
        flash[:notice] = 'Nomination was successfully created.'
        format.html { redirect_to(@nomination) }
        format.xml  { render :xml => @nomination, :status => :created, :location => @nomination }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nomination.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nominations/1
  # PUT /nominations/1.xml
  def update
    @nomination = Nomination.find(params[:id])

    respond_to do |format|
      if @nomination.update_attributes(params[:nomination])
        flash[:notice] = 'Nomination was successfully updated.'
        format.html { redirect_to(@nomination) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nomination.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nominations/1
  # DELETE /nominations/1.xml
  def destroy
    @nomination = Nomination.find(params[:id])
    @nomination.destroy

    respond_to do |format|
      format.html { redirect_to(nominations_url) }
      format.xml  { head :ok }
    end
  end

  private

  def add_parties
    @parties = Party.find([1,3,4,8,20,60,71,72])
  end

  def verify_access
    authenticate_or_request_with_http_basic("Documents Realm") do |username, password|
      username == "aruna" && password=="aruna"
    end
  end

end
