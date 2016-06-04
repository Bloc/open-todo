require 'spec_helper'

RSpec.describe Api::UsersController, type: :controller do
  describe "Index" do
    it "Authenticated user retrieve User index in JSON" do
      controller.should_receive(:authenticated?).and_return(true)
      get :index

      expect(response).to have_http_status(200)
      expect(response["Content-Type"]).to include("application/json")
    end
  end
end
