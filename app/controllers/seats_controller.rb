class SeatsController < ApplicationController

  def index
    @seats = AssemblySeat.find(:all)
  end

  def show
    @seat = AssemblySeat.find(params[:id])
    render :json => @seat.charts
  end

  def nearest
    @seat = AssemblySeat.find_closest(:origin => [params[:lat],params[:lng]])
    render :json => @seat.charts
  end

end
