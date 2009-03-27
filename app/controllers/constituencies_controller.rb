class ConstituenciesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def donothing
    @constituencies = Constituency.find(:all,:conditions => ["lat IS NOT NULL"])
  end

  def index
    render :json => Constituency.find(:all,:conditions => ["lat IS NOT NULL"]).to_json(:only=>[:id,:name,:lat,:lng])
  end

  def show
    con = Constituency.find(params[:id])
    render :json => { "piechart" => con.party_results.piedata ,
      "barchart" => con.party_results.barchart_by_year ,
      "core" => con.attributes.slice(*["name","lat","lng"]),
    "table" => con.candidate_results.table, "near" => con.near }.to_json
  end

  def update
    city = Constituency.find(params[:id])
    city.update_attributes(:lat => params[:lat], :lng => params[:lng])
    render :json => "saved"
  end

end
