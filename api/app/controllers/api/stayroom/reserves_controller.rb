class Api::Stayroom::ReservesController < ApplicationController
  before_action :auth_check, only: [:create]

  def index
    stayroom_reserves = StayroomReserve.one_month_resreves(params)
    render status: 200, json: { stayroom_reserves: stayroom_reserves }
  end
  
  def create
    stayroom_reserve = StayroomReserve.new
    if stayroom_reserve.create_reserves(stayroom_reserve_params)
      render status: 204
    else
      render status: 400, json: stayroom_reserve.errors.full_messages
    end
  end

  private
    def stayroom_reserve_params
      params.require(:stayroom_reserve).permit(:stayroom_id, :start_date, :end_date).merge(user_id: @user.id)
    end
end
