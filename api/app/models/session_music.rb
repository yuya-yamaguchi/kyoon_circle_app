class SessionMusic < ApplicationRecord
  belongs_to :event
  has_many :session_parts, dependent: :destroy
  
  validates :title, presence: true
  validates :title, length: { maximum: 40, message: 'は40文字以下で入力してください' }, allow_blank: true
  validates :artist, presence: true
  validates :artist, length: { maximum: 40, message: 'は40文字以下で入力してください' }, allow_blank: true

  before_create :set_youtube_url
  before_update :set_youtube_url

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
    musics_info
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
    update(status: session_music_status) if session_music_status != status
  end

  def set_youtube_url
    if music_url&.match('https://www.youtube.com/watch')
      edit_url = music_url.gsub('https://www.youtube.com/watch?v=', 'https://www.youtube.com/embed/')
      self.youtube_url_embed = edit_url.sub(/&.+/, '')
    elsif music_url&.match('https://youtu.be')
      self.youtube_url_embed = music_url.gsub('https://youtu.be', 'https://www.youtube.com/embed')
    elsif music_url.blank?
      self.youtube_url_embed = nil
    end
  end
end
