require 'rails_helper'

RSpec.describe User, type: :model do
  context "can not save" do
    it "ユーザ名、メール、パスワードあり" do
      expect(FactoryBot.create(:user)).to be_valid
    end
  end

  context "can not save" do
    it "ユーザ名なし" do
      expect(FactoryBot.build(:user, name: "")).to be_invalid
    end

    it "ユーザ名が21文字以上" do
      expect(FactoryBot.build(:user, name: "a" * 21)).to be_invalid
    end

    it "プロフィールが1001文字以上" do
      expect(FactoryBot.build(:user, profile: "a" * 1001)).to be_invalid
    end

    it "メールなし" do
      expect(FactoryBot.build(:user, email: "")).to be_invalid
    end

    it "メールアドレスが重複" do
      user1 = FactoryBot.create(:user, email: "test@example.com")
      expect(FactoryBot.build(:user, email: user1.email)).to be_invalid
    end
    
    it "パスワードなし" do
      expect(FactoryBot.build(:user, password: "")).to be_invalid
    end

    it "確認用パスワードなし" do
      expect(FactoryBot.build(:user, password_confirmation: "")).to be_invalid
    end

    it "パスワードと確認用パスワード不一致" do
      expect(FactoryBot.build(:user, password: "password1", password_confirmation: "password2")).to be_invalid
    end
  end
end
