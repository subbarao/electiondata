class ResultsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
    render :json => Constituency.find(:all,:conditions => ["lat IS NOT NULL"]).to_json(:only=>[:id,:name,:lat,:lng])
  end

  def show
    @nominations = Constituency.find(params[:id]).nominations
    render  :layout => false
  end

end
