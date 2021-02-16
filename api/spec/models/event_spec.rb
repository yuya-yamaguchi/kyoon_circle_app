require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) { FactoryBot.create(:user) }
  before do
    user
  end

  context 'can save' do
    it 'すべての入力あり' do
      expect(FactoryBot.create(:event, user_id: user.id)).to be_valid
    end

    it '終了時刻なし' do
      expect(FactoryBot.create(:event, end_datetime: '', user_id: user.id)).to be_valid
    end
  end

  context 'can not save' do
    it 'タイトルなし' do
      expect(FactoryBot.build(:event, title: '', user_id: user.id)).to be_invalid
    end

    it 'タイトルが41文字以上' do
      expect(FactoryBot.build(:event, title: 'a' * 41, user_id: user.id)).to be_invalid
    end

    it 'イベント種類が下限値オーバー' do
      expect(FactoryBot.build(:event, event_type: 0, user_id: user.id)).to be_invalid
    end

    it 'イベント種類が上限値オーバー' do
      expect(FactoryBot.build(:event, event_type: 5, user_id: user.id)).to be_invalid
    end

    it '内容なし' do
      expect(FactoryBot.build(:event, details: '', user_id: user.id)).to be_invalid
    end

    it '内容が1001字以上' do
      expect(FactoryBot.build(:event, details: 'a' * 1001, user_id: user.id)).to be_invalid
    end

    it '料金なし' do
      expect(FactoryBot.build(:event, fee: '', user_id: user.id)).to be_invalid
    end

    it '場所なし' do
      expect(FactoryBot.build(:event, place: '', user_id: user.id)).to be_invalid
    end

    it '開始時刻なし' do
      expect(FactoryBot.build(:event, start_datetime: '', user_id: user.id)).to be_invalid
    end
  end
end
