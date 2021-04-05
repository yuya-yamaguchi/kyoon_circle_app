require "rails_helper"

RSpec.describe StayroomReserveMailer, type: :mailer do
  describe "stayroom_reserved_email" do
    let(:mail) { StayroomReserveMailer.stayroom_reserved_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Stayroom reserved email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "stayroom_cancel_email" do
    let(:mail) { StayroomReserveMailer.stayroom_cancel_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Stayroom cancel email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
