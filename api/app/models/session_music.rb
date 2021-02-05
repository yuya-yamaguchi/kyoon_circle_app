class SessionMusic < ApplicationRecord
  has_many :session_parts

  def self.get_musics_info(event_id)
    session_musics = SessionMusic.where(event_id: event_id).order('status DESC')
    musics_info = []
    session_musics.each do |session_music|
      music_info = []
      music_info << session_music
      session_parts = session_music.session_parts.order('part_category_id')
      parts_info = []
      session_parts.each do |session_part|
        entry_users = session_part.users.select(:id, :name)
        part_info = []
        part_info << session_part
        part_info << entry_users
        parts_info << part_info
      end
      music_info << parts_info
      musics_info << music_info
    end
    return musics_info
  end

  def change_status
    # 必須のパートを取得
    session_parts = self.session_parts.where(status: 1)
    session_music_status = 1
    session_parts.each do |session_part|
      if session_part.user_entry_parts.count == 0
        session_music_status = 0
        break
      end
    end
    if session_music_status != self.status
      self.update(status: session_music_status)
    end
  end
end
