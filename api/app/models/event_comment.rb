class EventComment < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :text, presence: true
  validates :text, length: { maximum: 200, message: 'は200文字以下で入力してください' }, allow_blank: true

  scope :recent, -> { order('created_at DESC') }

  def set_out_params
    out_params = {
      id: id,
      text: text,
      created_at: created_at,
      user_id: user.id,
      user_name: user.name,
      user_avatar: user.avatar
    }
  end
end
