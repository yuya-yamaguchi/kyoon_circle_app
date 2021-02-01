# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_secure_token

  has_many :studio_reserves
  has_many :event_entries
  has_many :events, through: :event_entries
  has_many :event_comments
  has_many :user_instruments
  has_many :instruments, through: :user_instruments

  validates :name, presence: true
  validates :name, length: { maximum: 20, message: "は20文字以下で入力してください" }, allow_blank: true
  validates :profile, length: { maximum: 1000, message: "は1000文字以下で入力してください" }, allow_blank: true

  def set_instruments
    all_instruments = Instrument.order('id')
    user_instruments = self.instruments
    user_instrument_ids = user_instruments.map { |user_instrument| user_instrument.id }
    set_params = []
    all_instruments.each do |instrument|
      can_play = user_instrument_ids.include?(instrument.id)
      set_params << {id: instrument.id, name: instrument.name, can_play: can_play}
    end
    return set_params
  end
end
