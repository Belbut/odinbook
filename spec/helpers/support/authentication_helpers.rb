# https://rspec.info/features/3-12/rspec-core/example-groups/shared-context/

RSpec.shared_context "user logged in" do
  let(:devise_user) { users(:john) }

  before { sign_in(devise_user) }
end

RSpec.shared_context "user logged out" do
end
