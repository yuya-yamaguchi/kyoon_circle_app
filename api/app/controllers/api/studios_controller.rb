class Api::StudiosController < ApplicationController
  
  def show
    studio = Studio.find(params[:id])
    reserves_params = []
    now = Time.now.in_time_zone
    weeks = []
    # 1週間を配列に設定
    7.times do |i|
      weeks << now.to_date + i + (params[:week].to_i * 7)
    end
    studio_reserves = StudioReserve.where(studio_id: params[:id])
                                   .where('date between ? and ?', weeks[0], weeks[6])
    reserved = []
    # 予約済の日時を「YYYYMMDDH24MI」形式に変換
    studio_reserves.each do |studio_reserve|
      reserved << sprintf("%s%04d",
                          studio_reserve.date.strftime("%Y%m%d"),
                          studio_reserve.time)
    end
    # 0:00〜23:30をセット
    times = set_24times
    times.each do |time|
      work = []
      weeks.each do |day|
        check_time = sprintf("%s%02d%02d",
                             day.strftime("%Y%m%d"),
                             time[:hour],
                             time[:minutes])
        reserve_type = 0
        if reserved.include?(check_time)
          # 予約済
          reserve_type = 1
        elsif now.to_date > day || (now.to_date + 60) < day
          # 予約不可
          reserve_type = 2
        end
        work << { date: day, hour: time[:hour], minutes: time[:minutes], reserve_type: reserve_type }
      end
      reserves_params << work
    end
    render json: { studio: studio, reserves: reserves_params, weeks: weeks }
  end

  private
  def set_24times
    params = []
    minutes = [0, 30]
    24.times do |h|
      minutes.each do |m|
        params << { hour: h, minutes: m }
      end
    end
    return params
  end
end
