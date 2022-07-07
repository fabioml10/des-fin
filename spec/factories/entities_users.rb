FactoryBot.define do
  factory :entities_user do
    association :user
    association :entity
  end
end
