class Messageroom < ApplicationRecord
  has_many :messageroom_entries
  has_many :users, through: :messageroom_entries
  has_many :messages
end
