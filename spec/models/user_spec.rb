require "rails_helper"

RSpec.describe User, type: :model do
  context "Every user has one Profile" do
    xit { should_have_one(:profile) }
  end
end
