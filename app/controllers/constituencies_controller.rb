class ConstituenciesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def donothing
  end

  def index
    render :json => Constituency.find(:all,:conditions => ["lat IS NOT NULL"]).to_json(:only=>[:id,:name,:lat,:lng])
  end

  def show
    con = Constituency.find(params[:id])
    render :json => { "piedata" => con.party_results.piedata ,
    "map" => con.attributes.slice(*["lat","lng"]) }.to_json
  end

  def update
    city = Constituency.find(params[:id])
    city.update_attributes(:lat => params[:lat], :lng => params[:lng])
    render :json => "saved"
  end

end
