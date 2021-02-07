class SessionPart < ApplicationRecord
  belongs_to :session_music
  has_many :user_entry_parts
  has_many :users, through: :user_entry_parts
end
