# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :user_reserves
  has_many :event_entries
  has_many :events, through: :event_entries

  validates :name, presence: true
  validates :name, length: { maximum: 20, message: "は20文字以下で入力してください" }, allow_blank: true
  validates :profile, length: { maximum: 1000, message: "は1000文字以下で入力してください" }, allow_blank: true
end
