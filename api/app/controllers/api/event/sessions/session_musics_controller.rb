class Api::Event::Sessions::SessionMusicsController < ApplicationController
  before_action :auth_check, only: %i[create update]
  before_action :set_event, only: [:show]

  def index
    session_musics = SessionMusic.get_musics_info(params[:event_id])
    render status: 200, json: session_musics
  end

  def create
    session_music = SessionMusic.new(session_music_params)
    if session_music.save
      params[:session_parts].each{ |session_part| SessionPart.create(session_part_params(session_part, session_music.id)) }
      render status: 201, json: { session_music: session_music }
    else
      render status: 400, json: session_music.errors.full_messages
    end
  end

  def show
    session_music = SessionMusic.find_by(id: params[:id])
    if session_music.present?
      render status: 200, json: { event: @event, session_music: session_music }
    else
      render status: 404
    end
  end

  def edit
    session_music = SessionMusic.find_by(id: params[:id])
    session_parts = session_music.session_parts
    render status: 200, json: { session_music: session_music, session_parts: session_parts }
  end

  def update
    session_music = SessionMusic.find_by(id: params[:id])
    if session_music.update(session_music_params)
      params[:session_parts].each do |part_param|
        session_part = SessionPart.find_by(id: part_param[:id])
        session_part.update(status: part_param[:status])
      end
      render status: 201, json: { session_music: session_music }
    else
      render status: 400
    end
  end

  def destroy
    session_music = SessionMusic.find_by(id: params[:id])
    if session_music.destroy
      render status: 204
    else
      render status: 404
    end
  end

  private

  def session_music_params
    params.require(:session_music)
          .permit(:title, :artist, :music_url)
          .merge(user_id: @current_user.id, event_id: params[:event_id])
  end

  def session_part_params(session_part, session_music_id)
    session_part.permit(:part_category_id, :status).merge(session_music_id: session_music_id)
  end

  def set_event
    @event = Event.find_by(id: params[:event_id])
    return render status: 404 if @event.nil?
  end
end
