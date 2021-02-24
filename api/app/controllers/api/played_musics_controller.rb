class Api::PlayedMusicsController < ApplicationController
  def index
    played_musics = SessionMusic.where(status: 1).select('title', 'count(session_musics.id) as play_cnt').group(:title)
    render status: 200, json: { played_musics: played_musics }
  end
end
