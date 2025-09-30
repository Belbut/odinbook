# https://rspec.info/features/3-12/rspec-core/example-groups/shared-context/

RSpec.shared_context "user session" do
  let(:devise_user) { users(:john) }

  before { sign_in(devise_user) }
end

RSpec.shared_context "no user session" do
end
