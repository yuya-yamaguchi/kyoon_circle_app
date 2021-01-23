class Api::Studio::ReservesController < ApplicationController
  before_action :user_check, except: [:index]
  
  def index
    studio = Studio.find_by(id: params[:studio_id])
    reserves_params, weeks = studio.week_reserve(params)
    render status: 200, json: { studio: studio, reserves: reserves_params, weeks: weeks }
  end

  def create
    @studio = Studio.find(params[:studio_id])
    reserves_params = set_studio_reserves_params
    # 予約重複チェック
    reserve_cnt = StudioReserve.where(studio_id: reserves_params[:studio_id])
                               .where(date: reserves_params[:date])
                               .where('(start_time < ? AND end_time > ?) OR (start_time < ? AND end_time > ?)',
                                  parse_time(reserves_params[:start_time]), parse_time(reserves_params[:start_time]),
                                  parse_time(reserves_params[:end_time]), parse_time(reserves_params[:end_time])
                               ).count
    return render status: 400, json: { error_message: "すでに予約されています。別の時間帯をご指定ください。" } if reserve_cnt > 0 
    StudioReserve.create!(reserves_params)
    render json: 200
  end

  def destroy
    studio_reserve = StudioReserve.find(params[:id])
    now = Time.now.in_time_zone
    if studio_reserve.date <= now.to_date &&
       studio_reserve.start_time.strftime('%H%M') <= now.strftime('%H%M')
      render status: 400, json: { error_message: "開始日時を過ぎているため取消できません" }
      return
    end
    studio_reserve.destroy
    render json: 200
  end

  private
  def set_studio_reserves_params
    hour = params[:studio_reserve][:end_time][0,2].to_i - params[:studio_reserve][:start_time][0,2].to_i
    min = params[:studio_reserve][:end_time][3,2].to_i - params[:studio_reserve][:start_time][3,2].to_i
    fee = ((hour * 60 + min) / 60.0) * @studio.fee
    params.require(:studio_reserve)
          .permit(:date, :start_time, :end_time)
          .merge(studio_id: params[:studio_id], user_id: params[:user_id], reserve_type: 1, fee: fee.to_i)
  end

  def user_check
    return render status: 401, json:{ error_message: "会員登録（またはログイン）を行ってください" } if params[:user_id] == 0
    user = User.find_by(token: request.headers['Authorization'])
    return render status: 401, json:{ error_message: "認証に失敗しました。再度ログインしてお試しください。" } if user.nil?
  end

  def parse_time(value)
    (Time.parse(value) - 9*60*60).strftime('%H:%M:%S')
  end
end
 