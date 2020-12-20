class Api::Studio::ReservesController < ApplicationController
  
  def create
    studio_reserve = StudioReserve.new(studio_reserves_params)
    if studio_reserve.save
      render status: 200
    end
  end

  private
  def studio_reserves_params
    params.require(:studio_reserve)
          .permit(:date, :hour, :minutes)
          .merge(studio_id: params[:studio_id], user_id: params[:user_id], reserve_type: 1)
  end
end
