class News < ApplicationRecord
  validates :title, presence: true
  validates :title, length: { maximum: 40, message: 'は40文字以下で入力してください' }, allow_blank: true
  validates :details, presence: true
  validates :details, length: { maximum: 1000, message: 'は1000文字以下で入力してください' }, allow_blank: true

  scope :recent, ->(count) { order('created_at DESC').limit(count) }

  def push_line
    group_id = 'Cf3d1c27541003b233c4177ab4cb98680'
    message = {
      type: 'text',
      text: "#{title}

#{details}"
    }
    client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
    client.push_message(group_id, message)
  end
end
