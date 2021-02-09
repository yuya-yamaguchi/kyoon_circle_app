class AddYouTubeUrlTosessionMusic < ActiveRecord::Migration[6.0]
  def change
    add_column :session_musics, :music_url, :text
    add_column :session_musics, :youtube_url_embed, :text
  end
end
