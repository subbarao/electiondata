class ConstituenciesController < ApplicationController

  skip_before_filter :verify_authenticity_token
  def test
    con = Constituency.first
    render :json => {"name" => con.attributes["name"]}.to_json
  end

  def all
    render :json => Constituency.find(:all,:conditions => ["lat IS NOT NULL"],:limit=>5).collect { |e| { "core" => e.attributes.slice(*["name","lat","lng"]) ,"year" => e.party_results.with_party_results }}
  end

  def current
    @list = Constituency.find(:all,:conditions => ["lat IS NOT NULL"])
  end

  def donothing
    @constituencies = Constituency.find(:all,:conditions => ["lat IS NOT NULL"])
  end

  def find
    con = Constituency.find_closest(:origin => [params[:lat],params[:lng]])
    render :json => { "piechart" => con.party_results.piedata ,
      "barchart" => con.party_results.barchart_by_year ,
      "core" => con.attributes.except("created_at","updated_at"),
    "table" => con.candidate_results.table, "near" => con.near }.to_json
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
