RSpec.describe Format do
  describe "phone" do
    subject { described_class.phone(phone) }

    context "when phone is valid" do
      let(:phone) { Faker::PhoneNumber.cell_phone }
      let(:expected_result) { phone.to_s.gsub(/\D/, "") }

      it { is_expected.to eql(expected_result) }
    end

    context "when phone is invalid" do
      let(:phone) { nil }
      let(:expected_result) { nil }

      it { is_expected.to eql(expected_result) }
    end
  end
end
