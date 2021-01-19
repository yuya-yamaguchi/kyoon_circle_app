require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:user)       { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, :admin) }
  let(:events)     { FactoryBot.create_list(:event, 10, user_id: user.id) }
  let(:event_params) {
    { title: "param_title", details: "param_details", start_date: "2021-01-01", start_hour: "10", start_min: "15",
      end_hour: "20", end_min: "25", place: "param_place", fee: "param_fee",  max_entry: "1",  event_type: "1", line_msg_push: false }
  } 
  
  describe "#index" do
    context '対象データが存在する場合' do
      it '[HTTP:200]' do
        get '/api/events'
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#show" do
    context '取得可能な場合' do
      it '[HTTP:200] 取得したイベントデータを返却すること' do
        get "/api/events/#{events[0].id}"
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["event"]["title"]).to eq(events[0].title)
      end
    end
    
    context '存在しないイベントIDの場合' do
      it '[HTTP:404]' do
        get "/api/events/0"
        expect(response.status).to eq(404)
      end
    end
  end

  describe "#edit" do
    context '管理者権限がある場合' do
      it '[HTTP:200] データを取得できること' do
        get "/api/events/#{events[0].id}/edit", headers: { 'Authorization' => admin_user.token }
        expect(response).to have_http_status(200)
      end
    end
    
    context '管理者権限がない場合' do
      it '[HTTP:403] データを取得できないこと' do
        get "/api/events/#{events[0].id}/edit", headers: { 'Authorization' => user.token }
        expect(response).to have_http_status(403)
      end
    end
  end

  describe "#update" do
    context '管理者権限がある場合' do
      it '[HTTP:204] 対象レコードが更新されること' do
        put "/api/events/#{events[0].id}", params:{ event: event_params, user_id: admin_user.id}, headers: { 'Authorization' => admin_user.token }
        expect(events[0].reload.title).to eq ('param_title')
        expect(response).to have_http_status(204)
      end
    end

    context '管理者権限がない場合' do
      it '[HTTP:403] 対象レコードが更新されないこと' do
        put "/api/events/#{events[0].id}", params:{ event: event_params, user_id: user.id}, headers: { 'Authorization' => user.token }
        expect(events[0].reload.title).not_to eq ('param_title')
        expect(response).to have_http_status(403)
      end
    end

    context 'バリデーションエラーの場合' do
      it '[HTTP:422] 対象レコードが更新されないこと' do
        event_params[:title] = ""
        put "/api/events/#{events[0].id}", params:{ event: event_params, user_id: admin_user.id}, headers: { 'Authorization' => admin_user.token }
        expect(events[0].reload.title).not_to eq ('param_title')
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "#create" do
    subject {
      post "/api/events", params:{ event: event_params, user_id: admin_user.id}, headers: { 'Authorization' => admin_user.token }
    }
    context '管理者権限がある場合' do
      it '[HTTP:204] レコードが1件作成されること' do
        expect{ subject }.to change(Event, :count).by(1)
        expect(response).to have_http_status(201)
      end
    end

    context '管理者権限がない場合' do
      it '[HTTP:403] レコードが作成されないこと' do
        admin_user.token = user.token
        expect{ subject }.to change(Event, :count).by(0)
        expect(response).to have_http_status(403)
      end
    end

    context 'バリデーションエラーの場合' do
      it '[HTTP:422] レコードが作成されないこと' do
        event_params[:title] = ""
        expect{ subject }.to change(Event, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "#destroy" do
    subject {
      delete "/api/events/#{events[0].id}", headers: { 'Authorization' => admin_user.token }
    }
    before do
      events
    end
    context '管理者権限がある場合' do
      it '[HTTP:204] レコードが1件削除されること' do
        expect{ subject }.to change(Event, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end

    context '管理者権限がない場合' do
      it '[HTTP:403] レコードが削除されないこと' do
        admin_user.token = user.token
        expect{ subject }.to change(Event, :count).by(0)
        expect(response).to have_http_status(403)
      end
    end
  end
end
