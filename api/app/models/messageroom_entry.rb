class MessageroomEntry < ApplicationRecord
  belongs_to :messageroom
  belongs_to :user

  def self.get_belong_room(user_id1, user_id2)
    MessageroomEntry.where('user_id in (?, ?)', user_id1, user_id2)
                    .group(:messageroom_id)
                    .having('count(*) > ?', 1)
                    .select("messageroom_id")
  end
end
