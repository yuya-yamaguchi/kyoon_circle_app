class Batch::SendEmail < ApplicationRecord
  def self.studio_reserves_remind_email
    # 翌日の日付を取得
    bofore_1day = Time.now.in_time_zone + (60*60*24)
    studio_reserves = StudioReserve.where(date: bofore_1day.to_date)
    studio_reserves.each do |studio_reserve|
      studio_reserve.send_remind_email
    end
  end
end