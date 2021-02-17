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
  validates :title, length: { maximum: 40, message: 'は40文字以下で入力してください' }, allow_blank: true
  validates :details, presence: true
  validates :details, length: { maximum: 1000, message: 'は1000文字以下で入力してください' }, allow_blank: true
  validates :fee, presence: true
  validates :place, presence: true
  validates :start_datetime, presence: true

  scope :after_today,     -> { where('start_datetime >= ?', Time.now.in_time_zone.to_date) }
  scope :before_today,    -> { where('start_datetime <  ?', Time.now.in_time_zone.to_date) }
  scope :order_date,      -> { order('start_datetime') }
  scope :order_date_desc, -> { order('start_datetime DESC') }
  scope :recent,          ->(count) { after_today.order_date.limit(count) }

  def set_index_params
    out_params = {
      id: id,
      user_id: user_id,
      event_category: event_category.name,
      title: title,
      details: details,
      place: place,
      fee: fee,
      max_entry: max_entry,
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      created_at: created_at,
      updated_at: updated_at,
      line_msg_push: line_msg_push,
      entry_count: event_entries.count
    }
  end

  def set_edit_params
    # front側で編集する？
    end_hour = ''
    end_min = ''
    if end_datetime.present?
      end_hour = end_datetime.strftime('%H')
      end_min  = end_datetime.strftime('%M')
    end
    params = {
      id: id,
      title: title,
      details: details,
      event_category_id: event_category_id,
      fee: fee,
      place: place,
      max_entry: max_entry,
      start_date: start_datetime.strftime('%Y-%m-%d'),
      start_hour: start_datetime.strftime('%-H'),
      start_min: start_datetime.strftime('%M'),
      end_hour: end_hour,
      end_min: end_min
    }
  end

  def self.search(params)
    results = Event.all
    results = results.left_joins(:event_entries) if params[:order] == 'entry_cnt_desc'
    results = results.where('events.event_category_id = ?', params[:event_category]) if params[:event_category].to_i > 0
    results = results.after_today if params[:end_event_hide] == 'true'
    if params[:order].present?
      case params[:order]
      when 'date_desc'
        results = results.order_date_desc
      when 'entry_cnt_desc'
        results = results.group(:id).order('count(event_entries.id) DESC').order_date_desc
      end
    else
      results = results.order_date_desc
    end
    results
  end

  # ラインへの通知
  def push_line
    group_id = 'Cf3d1c27541003b233c4177ab4cb98680'
    text = "新しいイベントが追加されました！\n\n#{title}\n\n#{details}\n\n↓参加は下記から\n#{Constants::APP_URL}/event/#{id}"
    message = {
      type: 'text',
      text: text
    }
    client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
    response = client.push_message(group_id, message)
  end
end
