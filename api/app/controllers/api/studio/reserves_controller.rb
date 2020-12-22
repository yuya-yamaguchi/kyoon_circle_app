class Api::Studio::ReservesController < ApplicationController
  
  def create
    reserves_params = set_studio_reserves_params
    @start_time = sprintf("%02d%02d",
                          reserves_params[:start_hour].to_i,
                          reserves_params[:start_min].to_i)
    @end_time = sprintf("%02d%02d",
                        reserves_params[:end_hour].to_i,
                        reserves_params[:end_min].to_i)
    # 予約重複チェック
    reserve_cnt = StudioReserve.where(studio_id: reserves_params[:studio_id])
                               .where(date: reserves_params[:date])
                               .where('time between ? and ?', @start_time.to_i, @end_time.to_i)
                               .count
    if reserve_cnt > 0 
      render status: 500
      return
    end
    @start_time_i = reserves_params[:start_hour].to_i + (reserves_params[:start_min].to_f / 60.0)
    @end_time_i = reserves_params[:end_hour].to_i + (reserves_params[:end_min].to_f / 60.0)
    sa = @end_time_i - @start_time_i
    (sa * 2).to_i.times do |i|
      StudioReserve.create!(set_create_params(reserves_params, i))
    end
    UserReserve.create!(set_user_reserve_params(reserves_params))
  end

  private
  def set_studio_reserves_params
    params.require(:studio_reserve)
          .permit(:date, :start_hour, :start_min, :end_hour, :end_min)
          .merge(studio_id: params[:studio_id], user_id: params[:user_id], reserve_type: 1)
  end

  def set_create_params(reserves_params, i)
    min = reserves_params[:start_min].to_i + (i * 30)
    sho = min / 60
    hun = min % 60
    set_time = ((reserves_params[:start_hour].to_i + sho) * 100) + hun
    result = {
      studio_id: reserves_params[:studio_id],
      user_id: reserves_params[:user_id],
      date: reserves_params[:date],
      time: set_time,
      reserve_type: 1
    }
    return result
  end

  def set_user_reserve_params(reserves_params)
    user_reserve_params = {
      user_id: reserves_params[:user_id],
      studio_id: reserves_params[:studio_id],
      date: reserves_params[:date],
      start_time: @start_time.to_i,
      end_time: @end_time.to_i
    }
    return user_reserve_params
  end
end
