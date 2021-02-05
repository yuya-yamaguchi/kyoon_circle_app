class Api::Event::Sessions::SessionPartsController < ApplicationController
  before_action :auth_check

  def entry
    UserEntryPart.create(user_id: @user.id, session_part_id: params[:id])
    session_music = SessionMusic.find_by(id: params[:session_music_id])
    # セッション曲が未成立の場合、今回のエントリーによって成立したか判定。成立していれば更新
    session_music.change_status if session_music.status == 0
    render status: 201, json: { session_music: session_music }
  end

  def cancel
    user_entry_part = UserEntryPart.where(user_id: @user.id).where(session_part_id: params[:id]).first
    if user_entry_part.destroy
      session_music = SessionMusic.find_by(id: params[:session_music_id])
      session_music.change_status if session_music.status == 1
      render status: 201, json: { session_music: session_music }
    end
  end
end
