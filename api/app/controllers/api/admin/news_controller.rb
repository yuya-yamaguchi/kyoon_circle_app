class Api::Admin::NewsController < ApplicationController

  def index
    news = News.all.order('created_at DESC')
    render json: news
  end

  def show
    news = News.find(params[:id])
    render json: news
  end

  def create
    news = News.new(news_params)
    if news.save
      if news.line_msg_push
        news.push_line
      end
      render status: 200
    else
      render status: 500, json: news.errors.full_messages
    end
  end
  
  private
  def news_params
    params.require(:news).permit(:title, :details, :line_msg_push).merge(user_id: params[:user_id])
  end

end
