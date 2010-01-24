class SeatsController < ApplicationController

  def index
    @seats = Seat.find(:all)
  end

  def show
    @seat = Seat.find(params[:id])
    render :json => @seat.charts
  end

  def nearest
    @seat = Seat.find_closest(:origin => [params[:lat],params[:lng]])
    render :json => @seat.charts
  end

end
