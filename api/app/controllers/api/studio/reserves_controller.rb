class Api::Studio::ReservesController < ApplicationController
  before_action :user_check
  
  def create
    reserves_params = set_studio_reserves_params
    # 予約重複チェック
    reserve_cnt = StudioReserve.where(studio_id: reserves_params[:studio_id])
                               .where(date: reserves_params[:date])
                               .where('time between ? and ?', reserves_params[:start_time].to_i, reserves_params[:end_time].to_i)
                               .count
    return render status: 400, json: { error_message: "すでに予約されています。別の時間帯をご指定ください。" } if reserve_cnt > 0 
    
    reserve_block, how_hour = calc_reserves(reserves_params)
    # トランザクション要
    reserve_block.each_with_index do |reserve_time|
      StudioReserve.create!(set_create_params(reserves_params, reserve_time))
    end
    @studio = Studio.find(reserves_params[:studio_id])
    UserReserve.create!(set_user_reserve_params(reserves_params, how_hour))
    render json: 200
  end

  def destroy
    user_reserve = UserReserve.find(params[:id])
    now = Time.now.in_time_zone
    if user_reserve.date <= now.to_date &&
       user_reserve.start_time < (format("%02d" ,now.hour) + format("%02d" ,now.min)).to_i
      render status: 400, json: { error_message: "開始日時を過ぎているため取消できません" }
      return
    end
    studio_reserves = StudioReserve.where(studio_id: params[:studio_id])
                                   .where(date: user_reserve.date)
                                   .where('time between ? and ?', user_reserve.start_time, user_reserve.end_time)
    user_reserve.destroy
    studio_reserves.destroy_all
    render json: 200
  end

  private
  def set_studio_reserves_params
    params.require(:studio_reserve)
          .permit(:date, :start_time, :end_time)
          .merge(studio_id: params[:studio_id], user_id: params[:user_id], reserve_type: 1)
  end

  def set_create_params(reserves_params, reserve_time)
    create_params = {
      studio_id: reserves_params[:studio_id],
      user_id: reserves_params[:user_id],
      date: reserves_params[:date],
      time: reserve_time,
      reserve_type: reserves_params[:reserve_type]
    }
    return create_params
  end

  def set_user_reserve_params(reserves_params, how_hour)
    user_reserve_params = {
      user_id: reserves_params[:user_id],
      studio_id: reserves_params[:studio_id],
      date: reserves_params[:date],
      start_time: reserves_params[:start_time],
      end_time: reserves_params[:end_time],
      payment_fee: @studio.fee * how_hour.to_i
    }
    return user_reserve_params
  end

  def user_check
    return render status: 401, json:{ error_message: "会員登録（またはログイン）を行ってください" } if params[:user_id] == 0
    user = User.find_by(token: request.headers['Authorization'])
    return render status: 401, json:{ error_message: "認証に失敗しました。再度ログインしてお試しください。" } if user.nil?
  end

  # 予約する30分ごとの時間と予約時間を返却(ex. 600(6:00)〜730(7:30)の場合、[600, 630, 700], 1.5)
  def calc_reserves(reserves_params)
    how_time = reserves_params[:end_time].to_i - reserves_params[:start_time].to_i
    hour = how_time.div(100)
    half_hour = (how_time % 100) == 0 ? 0 : 0.5
    how_hour = hour.to_f + half_hour
    reserve_block = []
    ((hour.to_f + half_hour) * 2).to_i.times do |i|
      start_min = reserves_params[:start_time].last(2).to_i
      elapsed_min = start_min + (i * 30)
      reserve_block << (reserves_params[:start_time].to_i).round(-2) + ((elapsed_min / 60) * 100) + (elapsed_min % 60)
    end
    return reserve_block, how_hour
  end
end
 