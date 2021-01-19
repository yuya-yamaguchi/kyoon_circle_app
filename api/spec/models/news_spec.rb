require 'rails_helper'

RSpec.describe News, type: :model do
  let(:user) { FactoryBot.create(:user) }
  before do
    user
  end
  
  context 'can save' do
    it "すべての入力あり" do
      expect(FactoryBot.create(:news, user_id: user.id)).to be_valid
    end
  end

  context 'can not save' do
    it "タイトルなし" do
      expect(FactoryBot.build(:news, title: "", user_id: user.id)).to be_invalid
    end

    it "内容なし場合" do
      expect(FactoryBot.build(:news, details: "", user_id: user.id)).to be_invalid
    end
  end
end
