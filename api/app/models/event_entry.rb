class EventEntry < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validate :validate_max_entry
  validate :validate_hold_date
  # before_destroy :validate_hold_date_del

  private

  # 参加人数制限を超えていないか
  def validate_max_entry
    entry_cnt = event.event_entries.count
    errors.add(:max_entry, 'このイベントは定員に達したため参加いただけません') if event.max_entry != 0 && event.max_entry <= entry_cnt
  end

  # 開催日を過ぎていないか
  def validate_hold_date
    errors.add(:hold_date, '開催日を過ぎているため参加できません') if is_before_today
  end

  # 開催日を過ぎていないか（キャンセル時）
  def validate_hold_date_del
    if is_before_today
      errors.add(:hold_date, '開催日を過ぎているためキャンセルできません')
      throw(:abort)
    end
  end

  def is_before_today
    event.start_datetime.to_date < Time.now.in_time_zone.to_date
  end
end
