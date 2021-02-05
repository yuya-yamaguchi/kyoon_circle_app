class SessionPart < ApplicationRecord
  has_many :user_entry_parts
  has_many :users, through: :user_entry_parts
end
