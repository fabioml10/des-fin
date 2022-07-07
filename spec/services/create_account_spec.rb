RSpec.describe CreateAccount do
  describe "#call" do
    subject(:call) { described_class.call(payload) }

    let(:payload) do
      {
        name: name,
        entities: [
          {
            name: Faker::Company.name,
            users: [
              {
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                email: Faker::Internet.email,
                phone: "(11) 97111-0101",
              },
            ],
          },
        ],
      }
    end

    context "when account is created" do
      let(:expected_result) { ApplicationService::Result.new(true, Account.last, nil) }

      context "with name Fintera" do
        let(:name) { "Fintera" }

        it { is_expected.to eql(expected_result) }
      end

      context "without name Fintera" do
        let(:name) { Faker::Company.name }

        it { is_expected.to eql(expected_result) }
      end
    end

    context "when account is not created" do
      let(:name) { "" }
      let(:expected_result) { ApplicationService::Result.new(false, nil, "Name can't be blank") }

      it { is_expected.to eql(expected_result) }
    end

    context "when payload is invalid" do
      let(:payload) { {} }
      let(:expected_result) { ApplicationService::Result.new(false, nil, "Account is not valid") }

      it { is_expected.to eql(expected_result) }
    end
  end
end
