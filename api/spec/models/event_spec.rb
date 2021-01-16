require 'rails_helper'

RSpec.describe Event, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end
  
  it "[S]すべての入力がある場合" do
    expect(FactoryBot.create(:event, user_id: @user.id)).to be_valid
  end
  
  it "[S]終了時刻がない場合" do
    expect(FactoryBot.create(:event, end_datetime: "", user_id: @user.id)).to be_valid
  end

  it "[E]タイトルがない場合" do
    expect(FactoryBot.build(:event, title: "", user_id: @user.id)).to be_invalid
  end

  it "[E]タイトルが41文字以上の場合" do
    expect(FactoryBot.build(:event, title: "a" * 41, user_id: @user.id)).to be_invalid
  end

  it "[E]イベントの種類が下限値オーバーの場合" do
    expect(FactoryBot.build(:event, event_type: 0, user_id: @user.id)).to be_invalid
  end

  it "[E]イベントの種類が上限値オーバーの場合" do
    expect(FactoryBot.build(:event, event_type: 5, user_id: @user.id)).to be_invalid
  end

  it "[E]内容がない場合" do
    expect(FactoryBot.build(:event, details: "", user_id: @user.id)).to be_invalid
  end

  it "[E]内容が1001字以上の場合" do
    expect(FactoryBot.build(:event, details: "a" * 1001, user_id: @user.id)).to be_invalid
  end

  it "[E]料金がない場合" do
    expect(FactoryBot.build(:event, fee: "", user_id: @user.id)).to be_invalid
  end

  it "[E]場所がない場合" do
    expect(FactoryBot.build(:event, place: "", user_id: @user.id)).to be_invalid
  end

  it "[E]開始時刻がない場合" do
    expect(FactoryBot.build(:event,  start_datetime: "", user_id: @user.id)).to be_invalid
  end
end
