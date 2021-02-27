class Api::RelationshipsController < ApplicationController
  before_action :auth_check
  
  def create
    user = User.find(params[:followed_id])
    if @current_user.follow(user)
      render status: 201
    else
      render status: 400
    end
  end

  def destroy
    user = Relationship.find_by(followed_id: params[:id], follower_id: @current_user.id).followed
    if @current_user.unfollow(user)
      render status: 201
    else
      render status: 400
    end
  end
end
