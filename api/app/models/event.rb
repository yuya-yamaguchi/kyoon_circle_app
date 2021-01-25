class Event < ApplicationRecord
  require 'line/bot'

  has_many :event_entries,  dependent: :destroy
  has_many :event_comments, dependent: :destroy
  
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
    # front側で編集する？
    end_hour = ""
    end_min = ""
    if self.end_datetime.present?
      end_hour = self.end_datetime.strftime("%H")
      end_min  = self.end_datetime.strftime("%M")
    end
    params = {
      id:         self.id,
      title:      self.title,
      details:    self.details,
      event_type: self.event_type,
      fee:        self.fee,
      place:      self.place,
      max_entry:  self.max_entry,
      start_date: self.start_datetime.strftime("%Y-%m-%d"),
      start_hour: self.start_datetime.strftime("%-H"),
      start_min:  self.start_datetime.strftime("%M"),
      end_hour:   end_hour,
      end_min:    end_min
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
    return "このイベントは定員に達したため参加いただけません" if self.max_entry != 0 && self.max_entry <= entered_num
    # 開催日チェック
    return "開催日を過ぎているため参加できません" if hold_date_chk
    return ""
  end

  def cancel_check
    return "開催日を過ぎているためキャンセルできません" if hold_date_chk
    return ""
  end

  def self.search(event_params)
    results = Event.all
    results = results.where('event_type = ?', event_params[:event_type]) if event_params[:event_type] != nil && event_params[:event_type] != "0"
    results = results.order('start_datetime DESC')
    results
  end

  private
  def hold_date_chk
    now = Time.now.in_time_zone
    self.start_datetime.to_date < now.to_date ? true : false
  end
end
