require 'rails_helper'

RSpec.describe EntitiesUser, type: :model do
  describe "associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :entity }
  end
end
