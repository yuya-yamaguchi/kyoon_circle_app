class Api::Stayroom::ReservesController < ApplicationController
  before_action :auth_check, only: [:create]

  def index
    stayroom_reserves = StayroomReserve.one_month_resreves(params)
    render status: 200, json: { stayroom_reserves: stayroom_reserves }
  end

  def show
    stayroom_reserve = StayroomReserve.select('stayroom_reserves.*', 'users.name AS user_name', 'stayrooms.name AS room_name')
                                      .joins(:user).joins(:stayroom)
                                      .find_by(id: params[:id])
    render status: 200, json: { stayroom_reserve: stayroom_reserve }
  end
  
  def create
    stayroom_reserve = StayroomReserve.new(stayroom_reserve_params)
    if stayroom_reserve.save
      stayroom_reserve.reserve_line
      render status: 201, json: { stayroom_reserve: stayroom_reserve }
    else
      render status: 400, json: stayroom_reserve.errors.full_messages
    end
  end

  def destroy
    stayroom_reserve = StayroomReserve.find(params[:id])
    if stayroom_reserve.destroy
      stayroom_reserve.cancel_line
      render status: 201
    else
      render status: 400, json: stayroom_reserve.errors.full_messages
    end
  end

  private
    def stayroom_reserve_params
      params.require(:stayroom_reserve).permit(:stayroom_id, :checkin_date, :checkout_date).merge(user_id: @current_user.id)
    end
end
