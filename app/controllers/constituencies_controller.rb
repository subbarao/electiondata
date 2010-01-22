class ConstituenciesController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def test
    con = Constituency.first
    render :json => {"name" => con.attributes["name"]}.to_json
  end

  def all
    @json  = Constituency.all.collect { |e|
      {
        "core" => e.attributes.slice(*["name","lat","lng"]) ,
        "year" => e.party_results.with_party_results
      }
    }
    render :json => @json
  end

  def current
    @list = Constituency.find(:all,:conditions => ["lat IS NOT NULL"])
  end

  def donothing
    @constituencies = Constituency.all
  end

  def find
    con = Constituency.find_closest(:origin => [params[:lat],params[:lng]])
    render :json => { "piechart" => con.party_results.piedata ,
      "barchart" => con.party_results.barchart_by_year ,
      "core" => con.attributes.except("created_at","updated_at"),
    "table" => con.candidate_results.table, "near" => con.near }.to_json
  end

  def index
    @json = Constituency.all.to_json(:only=>[:id,:name,:lat,:lng])
    render :json => @json 
  end

  def show
    con = Constituency.find(params[:id])
    render :json => { "piechart" => con.party_results.piedata ,
      "barchart" => con.party_results.barchart_by_year ,
      "core" => con.attributes.slice(*["name","lat","lng"]),
    "table" => con.candidate_results.table, "near" => con.near }.to_json
  end

end
