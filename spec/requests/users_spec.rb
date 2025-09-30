require "rails_helper"
require_relative "../helpers/support/authentication_helpers"

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    context "with user logged in" do
      include_context "user session"
      it do
        get "/users"
        expect(response).to have_http_status(:success)
      end
      it do
        get "/users"
        expect(response).to render_template(:index)
      end
    end

    context "with user logged out" do
      include_context "no user session"
      it do
        get "/users"
        expect(response).to have_http_status(:redirect)
      end
      it do
        get "/users"
        expect(response).to redirect_to(:new_user_session)
      end
      it do
        get "/users"
        expect(response).to render_template(:index)
      end
    end
  end
end
