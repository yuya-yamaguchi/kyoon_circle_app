class EventComment < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :text, presence: true
  validates :text, length: { maximum: 200, message: "は200文字以下で入力してください" }, allow_blank: true

  def set_out_params
    out_params = {
      id:          self.id,
      text:        self.text,
      created_at:  self.created_at,
      user_id:     self.user.id,
      user_name:   self.user.name,
      user_avatar: self.user.avatar
    }
  end
end
