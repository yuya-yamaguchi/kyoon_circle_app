require "rails_helper"

RSpec.describe StudioReserveMailer, type: :mailer do
  describe "studio_reserved" do
    let(:mail) { StudioReserveMailer.studio_reserved }

    it "renders the headers" do
      expect(mail.subject).to eq("Studio reserved")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
