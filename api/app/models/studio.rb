class Studio < ApplicationRecord
  has_many :studio_reserves

  validates :name, presence: true
  validates :name, length: { maximum: 20, message: 'は20文字以下で入力してください' }, allow_blank: true
  validates :fee, presence: true

  # 1週間のスタジオ予約状態を設定
  def week_reserve(params)
    reserves_params = []
    now = Time.now.in_time_zone
    weeks = []
    # 1週間を配列に設定
    7.times do |i|
      weeks << now.to_date + i + (params[:week].to_i * 7)
    end
    # 1週間分のスタジオ予約を取得
    studio_reserves = self.studio_reserves.where('date between ? and ?', weeks[0], weeks[6])
    reserves = []
    # スタジオ予約を30分1ブロックで配列に設定
    studio_reserves.each do |studio_reserve|
      i = 0
      loop do
        reserved_time = (studio_reserve.start_time + (i * 30 * 60)).strftime('%H%M')
        if reserved_time < studio_reserve.end_time.strftime('%H%M')
          reserves << { time: studio_reserve.date.strftime('%Y%m%d') + reserved_time,
                        user_id: studio_reserve.user_id, studio_reserve_id: studio_reserve.id }
        else
          break
        end
        i += 1
      end
    end
    already_users = []
    # 0:00〜23:30をセット
    times = set_24times
    times.each do |time|
      work = []
      weeks.each do |day|
        check_time = format('%s%02d%02d', day.strftime('%Y%m%d'), time[:hour], time[:minutes])
        # 処理対象の日時が予約済であるかチェック
        reserved = reserves.find { |reserve| reserve[:time] == check_time }
        reserve_type = 0
        # 対象の日時が予約済の場合
        if !reserved.nil?
          # 取得済のユーザ情報があるか確認
          user_find = already_users.find { |user| user[:id] == reserved[:user_id] }
          # 未取得のユーザの場合
          if user_find.nil?
            user = User.find_by(id: reserved[:user_id])
            already_users << { id: user.id, name: user.name }
            username = user.name
            user_id = user.id
          else
            username = user_find[:name]
            user_id = user_find[:id]
          end
          studio_reserve_id = reserved[:studio_reserve_id]
          reserve_type = 1
        # 過去日付、または60日後の場合
        elsif now.to_date > day || (now.to_date + 60) < day
          reserve_type = 2 # 予約不可
        end
        work << { date: day, hour: time[:hour], minutes: time[:minutes], reserve_type: reserve_type, user_id: user_id,
                  username: username, studio_reserve_id: studio_reserve_id }
      end
      reserves_params << work
    end
    [reserves_params, weeks]
  end

  private

  def set_24times
    times = []
    24.times do |hour|
      [0, 30].each do |min|
        times << { hour: hour, minutes: min }
      end
    end
    times
  end
end

# 全studio_reservesに対してuserを読み込んだ場合
# Completed 200 OK in 1310ms (Views: 51.1ms | ActiveRecord: 33.6ms | Allocations: 80591)
# Completed 200 OK in 961ms (Views: 35.3ms | ActiveRecord: 17.2ms | Allocations: 54676)
# Completed 200 OK in 1086ms (Views: 32.7ms | ActiveRecord: 38.1ms | Allocations: 77269)

# 重複するuserは再度読込せず、変数に設定したuser情報を使用した場合
# Completed 200 OK in 122ms (Views: 37.9ms | ActiveRecord: 3.6ms | Allocations: 30843)
