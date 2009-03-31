class ResultsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
    render :json => {:seats => AssemblySeat.find(:all).collect{|s| s.attributes.slice(*["id","name","lat","lng"]) } }.to_json
  end

  def show
    @nominations = AssemblySeat.find(params[:id]).nominations
    render  :layout => false
  end
  def init

  end

end