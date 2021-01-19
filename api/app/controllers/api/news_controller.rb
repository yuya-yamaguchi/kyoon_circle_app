class Api::NewsController < ApplicationController
  before_action :user_check, only: [:create, :update, :destroy]
  before_action :admin_check, only: [:create, :update, :destroy]
  before_action :set_news, only: [:show, :update, :destroy]

  def index
    news = News.all.order('created_at DESC')
    render status: 200, json: news
  end

  def show
    render status: 200, json: @news
  end

  def create
    news = News.new(news_params)
    if news.save
      # ライン通知ありの場合、ライン通知を行う
      news.push_line if news.line_msg_push
      render status: 201, json: news
    else
      render status: 422, json: news.errors.full_messages
    end
  end

  def update
    if @news.update(news_params)
      render status: 204
    else
      render status: 422, json: @news.errors.full_messages
    end
  end

  def destroy
    if @news.destroy
      render status: 204
    else
      render status: 404, json: @news.errors.full_messages
    end
  end
  
  private
  def news_params
    params.require(:news).permit(:title, :details, :line_msg_push).merge(user_id: params[:user_id])
  end

  def user_check
    return render status: 401, json:{ error_message: "会員登録（またはログイン）を行ってください" } if params[:user_id] == 0
    @user = User.find_by(token: request.headers['Authorization'])
    return render status: 401, json:{ error_message: "認証に失敗しました。再度ログインしてお試しください。" } if @user.nil?
  end

  def admin_check
    return render status: 403, json:{ error_message: "操作権限がありません" } if @user.admin_type == 0
  end

  def set_news
    @news = News.find_by(id: params[:id])
    render status: 404 if @news.nil?
  end
end
