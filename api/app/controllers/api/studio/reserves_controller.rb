class Api::Studio::ReservesController < ApplicationController
  before_action :auth_check, except: [:index]

  def index
    studio = Studio.find_by(id: params[:studio_id])
    reserves_params, weeks = studio.week_reserve(params)
    render status: 200, json: { studio: studio, reserves: reserves_params, weeks: weeks }
  end

  def show
    studio_reserve = StudioReserve.select('users.name AS username', 'studio_reserves.*').joins(:user).find_by(id: params[:id])
    render status: 200, json: { studio_reserve: studio_reserve }
  end

  def create
    @studio = Studio.find(params[:studio_id])
    studio_reserve = StudioReserve.new(studio_reserves_params)
    if studio_reserve.save
      studio_reserve.reserve_line
      studio_reserve.send_reserved_email
      render status: 201, json: { studio_reserve: studio_reserve }
    else
      render status: 400, json: studio_reserve.errors.full_messages
    end
  end

  def destroy
    studio_reserve = StudioReserve.find(params[:id])
    if studio_reserve.destroy
      studio_reserve.cancel_line
      studio_reserve.send_cancel_email
      render status: 201
    else
      render status: 400, json: studio_reserve.errors.full_messages
    end
  end

  def update
    @studio = Studio.find(params[:studio_id])
    studio_reserve = StudioReserve.find(params[:id])
    if studio_reserve.update(studio_reserves_params)
      studio_reserve.update_line
      studio_reserve.send_update_email
      render status: 201, json: { studio_reserve: studio_reserve }
    else
      render status: 400, json: studio_reserve.errors.full_messages
    end
  end

  private

  def studio_reserves_params
    hour = params[:studio_reserve][:end_time][0, 2].to_i - params[:studio_reserve][:start_time][0, 2].to_i
    min = params[:studio_reserve][:end_time][3, 2].to_i - params[:studio_reserve][:start_time][3, 2].to_i
    fee = ((hour * 60 + min) / 60.0) * @studio.fee * params[:studio_reserve][:users_num].to_i
    params.require(:studio_reserve)
          .permit(:date, :start_time, :end_time, :users_num)
          .merge(studio_id: params[:studio_id], user_id: params[:user_id], reserve_type: 1, fee: fee.to_i)
  end
end
