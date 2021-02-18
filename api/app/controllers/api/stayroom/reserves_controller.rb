class Api::Stayroom::ReservesController < ApplicationController
  before_action :auth_check, only: [:create]

  def index
    stayroom_reserves = StayroomReserve.one_month_resreves(params)
    render status: 200, json: { stayroom_reserves: stayroom_reserves }
  end
  
  def create
    if StayroomReserve.create(stayroom_reserve_params)
      render status: 204
    end
  end

  private

    def stayroom_reserve_params
      params.require(:stayroom_reserve).permit(:date).merge(stayroom_id: params[:stayroom_id], user_id: @user.id)
    end
end
