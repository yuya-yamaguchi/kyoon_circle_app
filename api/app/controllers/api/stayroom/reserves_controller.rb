class Api::Stayroom::ReservesController < ApplicationController
  before_action :auth_check, only: [:create]

  def index
    stayroom_reserves = StayroomReserve.one_month_resreves(params)
    render status: 200, json: { stayroom_reserves: stayroom_reserves }
  end
  
  def create
    stayroom_reserve = StayroomReserve.new(stayroom_reserve_params)
    if stayroom_reserve.save
      render status: 201, json: { stayroom_reserve: stayroom_reserve }
    else
      render status: 400, json: stayroom_reserve.errors.full_messages
    end
  end

  private
    def stayroom_reserve_params
      params.require(:stayroom_reserve).permit(:stayroom_id, :checkin_date, :checkout_date).merge(user_id: @current_user.id)
    end
end
