class Event < ApplicationRecord
  require 'line/bot'

  has_many :event_entries, dependent: :destroy
  
  validates :title, presence: true
  validates :title, length: { maximum: 40, message: "は40文字以下で入力してください" }, allow_blank: true
  validates :event_type,
    numericality: {greater_than_or_equal_to: 1,
                   less_than_or_equal_to:    4,
                   message: "選択してください"
                  }
  validates :details, presence: true
  validates :details, length: { maximum: 1000, message: "は1000文字以下で入力してください" }, allow_blank: true
  validates :fee, presence: true
  validates :place, presence: true
  validates :start_datetime, presence: true
  
  def set_edit_params
    params = {
      id:         self.id,
      title:      self.title,
      details:    self.details,
      event_type: self.event_type,
      fee:        self.fee,
      place:      self.place,
      max_entry:  self.max_entry,
      start_date: self.start_datetime.strftime("%Y-%m-%d"),
      start_hour: self.start_datetime.strftime("%H"),
      start_min:  self.start_datetime.strftime("%M"),
      end_hour:   self.end_datetime.strftime("%H"),
      end_min:    self.end_datetime.strftime("%M")
    }
  end

  # ラインへの通知
  def push_line
    group_id = "Cf3d1c27541003b233c4177ab4cb98680"
    message = {
      type: 'text',
      text: "新しいイベントが投稿されました！
#{self.title}"
    }
    client = Line::Bot::Client.new { |config|
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
    response = client.push_message(group_id, message)
  end

  # イベントへのエントリーが可能かチェック
  def entry_check
    # 人数制限チェック
    entered_num = self.event_entries.count
    if self.max_entry != 0 && self.max_entry <= entered_num
      return "このイベントは定員に達したため参加いただけません"
    end
    # 期限超過チェック
    now = Time.now.in_time_zone
    if self.start_datetime.to_date < now.to_date
      return "期限を過ぎているため参加できません"
    end
    return ""
  end
end
