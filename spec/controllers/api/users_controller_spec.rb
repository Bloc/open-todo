require 'spec_helper'

RSpec.describe Api::UsersController, type: :controller do
  describe "Index" do
    it "Authenticated user retrieve User index in JSON" do
      allow(controller).to return(:authenticated?).and_return(true)
      get :index

      expect(response).to have_http_status(200)
      expect(response.content).to eq("application/json")


    end
  end
end
