class Api::Event::Sessions::SessionMusicsController < ApplicationController
  before_action :auth_check, only: [:create]

  def index
    session_musics = SessionMusic.get_musics_info(params[:event_id])
    render status: 200, json: session_musics
  end

  def create
    session_music = SessionMusic.new(session_music_params)
    if session_music.save
      params[:session_parts].length.times do |i|
        SessionPart.create(session_part_params(i, session_music.id))
      end
      render status: 201
    else
      render status: 400
    end
  end

  private
  def session_music_params
    params.require(:session_music).permit(:title, :artist).merge(user_id: @user.id, event_id: params[:event_id])
  end

  def session_part_params(i, session_music_id)
    params.require(:session_parts)[i].permit(:part_category_id, :status).merge(session_music_id: session_music_id)
  end
end
