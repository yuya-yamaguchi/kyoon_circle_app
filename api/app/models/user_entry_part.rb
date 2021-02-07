class UserEntryPart < ApplicationRecord
  belongs_to :session_part
  belongs_to :user
end
