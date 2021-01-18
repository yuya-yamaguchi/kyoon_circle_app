class Studio < ApplicationRecord
  has_many :studio_reserves

  validates :name, presence: true
  validates :name, length: { maximum: 20, message: "は20文字以下で入力してください" }, allow_blank: true
  validates :fee, presence: true

  def week_reserve(params)
    reserves_params = []
    now = Time.now.in_time_zone
    weeks = []
    # 1週間を配列に設定
    7.times do |i|
      weeks << now.to_date + i + (params[:week].to_i * 7)
    end
    studio_reserves = self.studio_reserves.where('date between ? and ?', weeks[0], weeks[6])
    reserved = []
    # 予約済の日時を「YYYYMMDDH24MI」形式に変換(ex.202004012030)
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
          reserve_type = 1 # 予約済
        elsif now.to_date > day || (now.to_date + 60) < day
          reserve_type = 2 # 予約不可
        end
        work << { date: day, hour: time[:hour], minutes: time[:minutes], reserve_type: reserve_type }
      end
      reserves_params << work
    end
    return reserves_params, weeks
  end

  private
  def set_24times
    times = []
    minutes = [0, 30]
    24.times do |h|
      minutes.each do |m|
        times << { hour: h, minutes: m }
      end
    end
    return times
  end
end
