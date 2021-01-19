require 'rails_helper'

RSpec.describe "News", type: :request do
  let(:user)       { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, :admin) }
  let(:news)       { FactoryBot.create_list(:news, 10, user_id: user.id) }
  let(:news_params) {
    { title: "param_title", details: "param_details", line_msg_push: false }
  }
  before do
    user
    admin_user
    news
    news_params
  end
  describe "#index" do
    context '対象データが存在する場合' do
      it '[HTTP:200]' do
        get '/api/news'
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json.length).to eq(10)
      end
    end
  end

  describe "#show" do
    context '取得可能な場合' do
      it '[HTTP:200] 取得したイベントデータを返却すること' do
        get "/api/news/#{news[0].id}"
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["title"]).to eq(news[0].title)
      end
    end
    
    context '存在しないイベントIDの場合' do
      it '[HTTP:404]' do
        get "/api/news/0"
        expect(response.status).to eq(404)
      end
    end
  end

  describe "#update" do
    context '管理者権限がある場合' do
      it '[HTTP:204] 対象レコードが更新されること' do
        put "/api/news/#{news[0].id}", params:{ news: news_params, user_id: admin_user.id}, headers: { 'Authorization' => admin_user.token }
        expect(news[0].reload.title).to eq ('param_title')
        expect(response).to have_http_status(204)
      end
    end

    context '管理者権限がない場合' do
      it '[HTTP:403] 対象レコードが更新されないこと' do
        put "/api/news/#{news[0].id}", params:{ news: news_params, user_id: user.id}, headers: { 'Authorization' => user.token }
        expect(news[0].reload.title).not_to eq ('param_title')
        expect(response).to have_http_status(403)
      end
    end

    context 'バリデーションエラーの場合' do
      it '[HTTP:422] 対象レコードが更新されないこと' do
        news_params[:title] = ""
        put "/api/news/#{news[0].id}", params:{ news: news_params, user_id: admin_user.id}, headers: { 'Authorization' => admin_user.token }
        expect(news[0].reload.title).not_to eq ('param_title')
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "#create" do
    subject {
      post "/api/news", params:{ news: news_params, user_id: admin_user.id}, headers: { 'Authorization' => admin_user.token }
    }
    context '管理者権限がある場合' do
      it '[HTTP:204] レコードが1件作成されること' do
        expect{ subject }.to change(News, :count).by(1)
        expect(response).to have_http_status(201)
      end
    end

    context '管理者権限がない場合' do
      it '[HTTP:403] レコードが作成されないこと' do
        admin_user.token = user.token
        expect{ subject }.to change(News, :count).by(0)
        expect(response).to have_http_status(403)
      end
    end

    context 'バリデーションエラーの場合' do
      it '[HTTP:422] レコードが作成されないこと' do
        news_params[:title] = ""
        expect{ subject }.to change(News, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "#destroy" do
    subject {
      delete "/api/news/#{news[0].id}", headers: { 'Authorization' => admin_user.token }
    }
    context '管理者権限がある場合' do
      it '[HTTP:204] レコードが1件削除されること' do
        expect{ subject }.to change(News, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end

    context '管理者権限がない場合' do
      it '[HTTP:403] レコードが削除されないこと' do
        admin_user.token = user.token
        expect{ subject }.to change(News, :count).by(0)
        expect(response).to have_http_status(403)
      end
    end
  end
end
