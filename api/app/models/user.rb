class User < ActiveRecord::Base
  # attr_accessor :name, :email

  has_secure_token    # has_secure_token(gem)
  has_secure_password # bcrypt(gem)

  has_many :studio_reserves
  has_many :event_entries
  has_many :events, through: :event_entries
  has_many :event_comments
  has_many :user_instruments
  has_many :instruments, through: :user_instruments

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :name, length: { maximum: 20, message: 'は20文字以下で入力してください' }, allow_blank: true
  validates :profile, length: { maximum: 1000, message: 'は1000文字以下で入力してください' }, allow_blank: true
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  def set_instruments
    instruments = Instrument.order('id')
    user_instruments = self.instruments
    user_instrument_ids = user_instruments.map { |user_instrument| user_instrument.id }
    set_params = []
    instruments.each do |instrument|
      can_play = user_instrument_ids.include?(instrument.id)
      set_params << { id: instrument.id, name: instrument.name, can_play: can_play }
    end
    set_params
  end

  def send_reset_password_email
    self.reset_password_token = new_token
    self.reset_password_sent_at = Time.now
    if save
      UserMailer.reset_password_email(self).deliver
      true
    else
      false
    end
  end

  def new_token
    SecureRandom.urlsafe_base64
  end
end
