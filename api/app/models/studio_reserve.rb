class StudioReserve < ApplicationRecord
  belongs_to :user

  validate :validate_reserve_duplicate
  before_destroy :validate_before_today

  scope :after_today,  -> { where('date >= ?', Time.now.in_time_zone.to_date) }
  scope :bofore_today, -> { where('date <  ?', Time.now.in_time_zone.to_date) }
  scope :date_desc,    -> { order('date DESC') }
  scope :time_desc,    -> { order('start_time DESC') }
  scope :after_today_desc,  -> { after_today.date_desc.time_desc }
  scope :bofore_today_desc, -> { bofore_today.date_desc.time_desc }

  private

  # 予約の重複がないか確認する
  def validate_reserve_duplicate
    studio_reserves = StudioReserve.where(studio_id: studio_id)
                                   .where(date: date)
    is_reserved = false
    # 対象の予約日内で時間の重複がないかチェック(UTC時刻だと不整合のケースがあるためSQLで比較せず抽出後JSTで比較)
    studio_reserves.each do |reserve|
      if reserve.start_time.to_s(:time) >= start_time.to_s(:time)
        if reserve.start_time.to_s(:time) < end_time.to_s(:time)
          is_reserved = true
          break
        end
      elsif reserve.start_time.to_s(:time) > end_time.to_s(:time)
        is_reserved = true
        break
      end
    end
    errors.add(:date, 'すでに予約されています。別の時間帯を指定してください。') if is_reserved
  end

  def validate_before_today
    now = Time.now.in_time_zone
    is_cant_cancel = false
    if date < now.to_date
      is_cant_cancel = true
    elsif date == now.to_date
      is_cant_cancel = true if start_time.to_s(:time) <= now.to_s(:time)
    end
    if is_cant_cancel
      errors.add(:date, '開始日時を過ぎているため取消できません')
      throw(:abort)
    end
  end
end
