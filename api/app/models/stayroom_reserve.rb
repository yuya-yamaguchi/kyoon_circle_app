class StayroomReserve < ApplicationRecord
  belongs_to :user
  belongs_to :stayroom

  validates :checkin_date, presence: true
  validates :checkout_date, presence: true
  validate  :validate_date_consistency
  before_validation  :validate_reserve_duplicate

  CHECKIN_OUT_MSG      = 'チェックアウト日はチェックイン日より後を指定してください'
  AFTER_TODAY_MSG      = '本日日付以降を指定してください'
  ALREADY_RESERVED_MSG = 'すでに予約されています'

  scope :after_today,  -> { where('checkin_date >= ?', Time.now.in_time_zone.to_date) }
  scope :bofore_today, -> { where('checkin_date <  ?', Time.now.in_time_zone.to_date) }
  scope :date_desc,    -> { order('checkin_date DESC') }
  scope :after_today_desc,  -> { after_today.date_desc }
  scope :before_today_desc, -> { bofore_today.date_desc }
  scope :reserve_duplicate, ->(checkin_date, checkout_date) do
    where('(checkin_date <= ? AND checkout_date > ?) OR
           (checkin_date < ? AND checkout_date >= ?) OR
           (? <= checkin_date AND checkout_date <= ?)',
           checkin_date,  checkin_date,
           checkout_date, checkout_date,
           checkin_date,  checkout_date)
  end

  # 1ヶ月分の予約情報を取得
  def self.one_month_resreves(params)
    reserves = []
    stayroom_reserves = StayroomReserve.select(:id, :stayroom_id, :user_id, :checkin_date, :checkout_date, 'users.name')
                                       .left_joins(:user)
                                       .where('checkin_date between ? AND ?', params[:calendar_start], params[:calendar_end])
    stayroom_reserves.each do |stayroom_reserve|
      reserve_days = (stayroom_reserve.checkout_date - stayroom_reserve.checkin_date).to_i
      reserve_days.times do |i|
        reserves << { id: stayroom_reserve.id,
                      stayroom_id: stayroom_reserve.stayroom_id,
                      user_id: stayroom_reserve.user_id,
                      user_name: stayroom_reserve.name,
                      date: stayroom_reserve.checkin_date + i
                    }
      end
    end
    return reserves
  end

  def reserve_line
    text = "【宿泊予約】\n宿泊の予約が行われました\n\n予約者：#{self.user.name}\n部屋名：#{self.stayroom.name}\nチェックイン：#{checkin_date.strftime('%Y/%m/%d')}\nチェックアウト：#{checkout_date.strftime('%Y/%m/%d')}"
    push_line(text)
  end

  def cancel_line
    text = "【宿泊予約キャンセル】\n宿泊の予約キャンセルが行われました\n\n予約者：#{self.user.name}\n部屋名：#{self.stayroom.name}\nチェックイン：#{checkin_date.strftime('%Y/%m/%d')}\nチェックアウト：#{checkout_date.strftime('%Y/%m/%d')}"
    push_line(text)
  end

  def send_reserved_email
    StayroomReserveMailer.stayroom_reserved_email(self, self.user).deliver
  end

  def send_cancel_email
    StayroomReserveMailer.stayroom_cancel_email(self, self.user).deliver
  end

  private
  def validate_date_consistency
    # チェックアウトがチェックイン以前の場合
    errors[:base] << CHECKIN_OUT_MSG if self.checkin_date >= self.checkout_date
    # チェックイン日が本日日付以降の場合
    errors[:base] << AFTER_TODAY_MSG if self.checkin_date < Time.now.in_time_zone.to_date
    throw(:abort) if errors[:base].present?
  end

  def validate_reserve_duplicate
    # 部屋を指定する場合
    if self.stayroom_id.to_i > 0
      results = StayroomReserve.where(stayroom_id: self.stayroom_id).reserve_duplicate(self.checkin_date, self.checkout_date)
      if results.count > 0
        errors[:base] << ALREADY_RESERVED_MSG
        throw(:abort)
      end
    # 部屋を指定しない場合
    else
      stayroom_id = vacant_room(self.checkin_date, self.checkout_date)
      if stayroom_id
        self.stayroom_id = stayroom_id
      else
        errors[:base] << ALREADY_RESERVED_MSG
        throw(:abort)
      end
    end
  end

  # 予約日付内で空室の部屋(1部屋)を取得
  def vacant_room(checkin_date, checkout_date)
    stayrooms = Stayroom.all
    stayrooms.each do |stayroom|
      results = stayroom.stayroom_reserves.reserve_duplicate(checkin_date, checkout_date)
      if results.count == 0
        return stayroom.id
      end
    end
    return false
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
