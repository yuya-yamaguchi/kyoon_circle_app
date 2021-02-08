class Api::Event::Sessions::SessionPartsController < ApplicationController
  before_action :auth_check

  def entry
    event_entry = EventEntry.where(user_id: params[:user_id]).where(event_id: params[:event_id]).first
    # ユーザがイベントに未参加の場合、entryレコードを作成
    EventEntry.create(user_id: params[:user_id], event_id: params[:event_id]) if event_entry.nil?
    if UserEntryPart.create(user_id: params[:user_id], session_part_id: params[:id], event_id: params[:event_id])
      session_music = SessionMusic.find_by(id: params[:session_music_id])
      # セッション曲が未成立の場合、今回のエントリーによって成立したか判定。成立していれば更新
      session_music.change_status if session_music.status == 0
      render status: 201, json: { session_music: session_music }
    end
  end

  def cancel
    user_entry_part = UserEntryPart.where(user_id: params[:user_id]).where(session_part_id: params[:id]).first
    if user_entry_part.destroy
      session_music = SessionMusic.find_by(id: params[:session_music_id])
      session_music.change_status if session_music.status == 1
      render status: 201, json: { session_music: session_music }
    end
  end
end
