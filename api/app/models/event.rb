class Event < ApplicationRecord
  require 'line/bot'

  has_many :event_entries,  dependent: :destroy
  has_many :users, through: :event_entries
  has_many :event_comments, dependent: :destroy
  belongs_to :event_category
  has_one  :event_session, dependent: :destroy
  has_many :session_musics, dependent: :destroy
  has_many :user_entry_parts, dependent: :destroy
  
  validates :title, presence: true
  validates :title, length: { maximum: 40, message: "は40文字以下で入力してください" }, allow_blank: true
  validates :details, presence: true
  validates :details, length: { maximum: 1000, message: "は1000文字以下で入力してください" }, allow_blank: true
  validates :fee, presence: true
  validates :place, presence: true
  validates :start_datetime, presence: true

  scope :after_today,     -> { where('start_datetime >= ?', Time.now.in_time_zone.to_date) }
  scope :before_today,    -> { where('start_datetime <  ?', Time.now.in_time_zone.to_date) }
  scope :order_date,      -> { order('start_datetime') }
  scope :order_date_desc, -> { order('start_datetime DESC') }
  scope :recent,          -> (count) { after_today.order_date.limit(count) }
  
  def set_index_params
    out_params = {
      id:             self.id,
      user_id:        self.user_id,
      event_category: self.event_category.name,
      title:          self.title,
      details:        self.details,
      place:          self.place,
      fee:            self.fee,
      max_entry:      self.max_entry,
      start_datetime: self.start_datetime,
      end_datetime:   self.end_datetime,
      created_at:     self.created_at,
      updated_at:     self.updated_at,
      line_msg_push:  self.line_msg_push,
      entry_count:    self.event_entries.count
    }
  end

  def set_edit_params
    # front側で編集する？
    end_hour = ""
    end_min = ""
    if self.end_datetime.present?
      end_hour = self.end_datetime.strftime("%H")
      end_min  = self.end_datetime.strftime("%M")
    end
    params = {
      id:                self.id,
      title:             self.title,
      details:           self.details,
      event_category_id: self.event_category_id,
      fee:               self.fee,
      place:             self.place,
      max_entry:         self.max_entry,
      start_date:        self.start_datetime.strftime("%Y-%m-%d"),
      start_hour:        self.start_datetime.strftime("%-H"),
      start_min:         self.start_datetime.strftime("%M"),
      end_hour:          end_hour,
      end_min:           end_min
    }
  end

  def self.search(params)
    results = Event.all
    results = results.left_joins(:event_entries) if params[:order] == "entry_cnt_desc" # ソート条件が参加人数順の場合、event_entriesとの外部結合が必要なため、最初に結合する
    results = results.where('events.event_category_id = ?', params[:event_category]) if params[:event_category].to_i > 0
    results = results.after_today if params[:end_event_hide] == "true"
    if params[:order].present?
      case params[:order]
      when 'date_desc' then
        results = results.order_date_desc
      when 'entry_cnt_desc' then
        results = results.group(:id).order('count(event_entries.id) DESC').order_date_desc
      else
      end
    else
      results = results.order_date_desc
    end
    return results
  end

  # ラインへの通知
  def push_line
    group_id = "Cf3d1c27541003b233c4177ab4cb98680"
    text = "新しいイベントが投稿されました！\n#{self.title}\n#{Constants::APP_URL}/event/#{self.id}"
    message = {
      type: 'text',
      text: text
    }
    client = Line::Bot::Client.new { |config|
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
    response = client.push_message(group_id, message)
  end
end
