require 'rails_helper'

RSpec.describe News, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end
  
  it "[S]すべての入力がある場合" do
    expect(FactoryBot.create(:news, user_id: @user.id)).to be_valid
  end

  it "[E]タイトルがない場合" do
    expect(FactoryBot.build(:news, title: "", user_id: @user.id)).to be_invalid
  end

  it "[E]内容がない場合" do
    expect(FactoryBot.build(:news, details: "", user_id: @user.id)).to be_invalid
  end
end
