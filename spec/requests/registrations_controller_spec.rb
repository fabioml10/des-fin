RSpec.describe "Api::V1::RegistrationsController", type: :request do
  describe "POST #create" do
    before { post api_v1_registrations_path(params: params) }

    let(:params) do
      {
        account: {
          name: account_name,
          from_partner: true,
          users: [{
            email: user_email,
            first_name: Faker::Name.female_first_name,
            last_name: Faker::Name.last_name,
            phone: Faker::PhoneNumber.cell_phone,
          }],
        },
      }
    end
    let(:account_name) { Faker::Superhero.name }
    let(:user_email) { Faker::Internet.email }

    context "with valid params" do
      context "with fintera name and users" do
        let(:account_name) { "Fintera" }
        let(:user_email) { "fintera@fintera.com.br" }

        it "renders 200 success" do
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to include({ "message" => "Registro realizado com sucesso" })
        end
      end

      context "without name Fintera and users Fintera" do
        it "renders 200 success" do
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to include({ "message" => "Registro realizado com sucesso" })
        end
      end
    end

    context "with invalid params" do
      let(:account_name) { "" }

      it "renders 422 unprocessable_entity" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include({ "error" => "Name can't be blank" })
      end
    end
  end
end
