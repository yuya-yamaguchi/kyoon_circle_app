class Api::StudiosController < ApplicationController
  
  def show
    studio = Studio.find(params[:id])
    reserves_params = []
    today = Date.today
    weeks = []
    # 1週間を配列に設定
    7.times do |i|
      weeks << today + i
    end
    studio_reserves = StudioReserve.where(studio_id: params[:id])
                                   .where('date between ? and ?', weeks[0], weeks[6])
    reserved = []
    studio_reserves.each do |studio_reserve|
      reserved << sprintf("%s%02d%02d",
                          studio_reserve.date.strftime("%Y%m%d"),
                          studio_reserve.hour,
                          studio_reserve.minutes)
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
        reserve = reserved.include?(check_time)
        work << { date: day, hour: time[:hour], minutes: time[:minutes], reserved_flg: reserve }
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
