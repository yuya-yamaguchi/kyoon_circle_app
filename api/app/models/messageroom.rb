class Messageroom < ApplicationRecord
  has_many :messageroom_entries
  has_many :users, through: :messageroom_entries
  has_many :messages
  
  # メッセージをしているユーザとメッセージの一覧取得
  def get_messages_list(user_id)
    message = self.messages.order('created_at DESC').first
    return if message.nil?
    user = self.users.where.not(id: user_id).first
    result = {
      text:       message.text,
      user_id:    user.id,
      user_name:  user.name,
      avatar:     user.avatar,
      created_at: message.created_at
    }
  end
end
