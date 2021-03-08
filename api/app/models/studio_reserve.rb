class StudioReserve < ApplicationRecord
  belongs_to :user

  validate :validate_reserve_duplicate
  validate :validate_before_today
  before_destroy :validate_before_today

  scope :after_today,  -> { where('date >= ?', Time.now.in_time_zone.to_date) }
  scope :bofore_today, -> { where('date <  ?', Time.now.in_time_zone.to_date) }
  scope :date_desc,    -> { order('date DESC') }
  scope :time_desc,    -> { order('start_time DESC') }
  scope :after_today_desc,  -> { after_today.date_desc.time_desc }
  scope :bofore_today_desc, -> { bofore_today.date_desc.time_desc }

  def reserve_line
    text = "【スタジオ予約】\nスタジオ予約が行われました\n\n予約者：#{self.user.name}\n日時　：#{date.strftime('%Y/%m/%d')} #{start_time.strftime('%H:%M')}〜#{end_time.strftime('%H:%M')}\n人数　：#{users_num}人\n料金　：#{fee}円"
    push_line(text)
  end

  def cancel_line
    text = "【予約キャンセル】\nスタジオの予約がキャンセルされました\n\n予約者：#{self.user.name}\n日時　：#{date.strftime('%Y/%m/%d')} #{start_time.strftime('%H:%M')}〜#{end_time.strftime('%H:%M')}\n人数　：#{users_num}人\n料金　：#{fee}円"
    push_line(text)
  end

  private

  # 予約の重複がないか確認する
  def validate_reserve_duplicate
    studio_reserves = StudioReserve.where(studio_id: studio_id)
                                   .where(date: date)
    is_reserved = false
    # 対象の予約日内で時間の重複がないかチェック(UTC時刻だと不整合のケースがあるためSQLで比較せず抽出後JSTで比較)
    studio_reserves.each do |reserve|
      if reserve.start_time.to_s(:time) >= start_time.to_s(:time)
        if reserve.start_time.to_s(:time) < conv_time(end_time.to_s(:time))
          is_reserved = true
          break
        end
      else
        if conv_time(reserve.end_time.to_s(:time)) > start_time.to_s(:time)
          is_reserved = true
          break
        end
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
      # 更新処理がある場合、問題あり（登録更新時と削除時でメソッドを分ける？？）
      message = id.present? ? '開始日時を過ぎているため取消できません' : '開始日時を過ぎているため予約できません'
      errors[:base] << message
      throw(:abort)
    end
  end

  # 終了時刻の「00:00」を「24:00」として扱いたいため変換
  def conv_time(time)
    return (time == '00:00') ? '24:00' : time
  end

  def push_line(text)
    if Rails.env.production?
      group_id = ENV['LINE_STUDIO_RESERVE_GROUPID']
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
end
