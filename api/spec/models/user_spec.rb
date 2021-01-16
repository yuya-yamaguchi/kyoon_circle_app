require 'rails_helper'

RSpec.describe User, type: :model do
  it "[S]ユーザ名、メール、パスワードがある場合、正常" do
    expect(FactoryBot.create(:user)).to be_valid
  end

  it "[E]ユーザ名がない場合" do
    expect(FactoryBot.build(:user, name: "")).to be_invalid
  end

  it "[E]ユーザ名が21文字以上の場合" do
    expect(FactoryBot.build(:user, name: "a" * 21)).to be_invalid
  end

  it "[E]プロフィールが1001文字以上の場合" do
    expect(FactoryBot.build(:user, profile: "a" * 1001)).to be_invalid
  end

  it "[E]メールがない場合" do
    expect(FactoryBot.build(:user, email: "")).to be_invalid
  end

  it "[E]重複したメールアドレスの場合" do
    user1 = FactoryBot.create(:user, email: "test@example.com")
    expect(FactoryBot.build(:user, email: user1.email)).to be_invalid
  end
  
  it "[E]パスワードがない場合" do
    expect(FactoryBot.build(:user, password: "")).to be_invalid
  end

  it "[E]確認用パスワードがない場合" do
    expect(FactoryBot.build(:user, password_confirmation: "")).to be_invalid
  end

  it "[E]パスワードと確認用パスワードが一致しない場合" do
    expect(FactoryBot.build(:user, password: "password1", password_confirmation: "password2")).to be_invalid
  end
end
