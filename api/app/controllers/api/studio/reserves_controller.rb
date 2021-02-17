class Api::Studio::ReservesController < ApplicationController
  before_action :auth_check, except: [:index]

  def index
    studio = Studio.find_by(id: params[:studio_id])
    reserves_params, weeks = studio.week_reserve(params)
    render status: 200, json: { studio: studio, reserves: reserves_params, weeks: weeks }
  end

  def create
    @studio = Studio.find(params[:studio_id])
    studio_reserve = StudioReserve.new(studio_reserves_params)
    if studio_reserve.save
      render status: 200
    else
      render status: 400, json: { error_message: studio_reserve.errors.full_messages[0] }
    end
  end

  def destroy
    studio_reserve = StudioReserve.find(params[:id])
    if studio_reserve.destroy
      render status: 200
    else
      render status: 400, json: { error_message: studio_reserve.errors.full_messages[0] }
    end
  end

  private

  def studio_reserves_params
    hour = params[:studio_reserve][:end_time][0, 2].to_i - params[:studio_reserve][:start_time][0, 2].to_i
    min = params[:studio_reserve][:end_time][3, 2].to_i - params[:studio_reserve][:start_time][3, 2].to_i
    fee = ((hour * 60 + min) / 60.0) * @studio.fee
    params.require(:studio_reserve)
          .permit(:date, :start_time, :end_time)
          .merge(studio_id: params[:studio_id], user_id: params[:user_id], reserve_type: 1, fee: fee.to_i)
  end
end
