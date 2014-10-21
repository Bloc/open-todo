require 'rails_helper'

describe "Authorization for API" do
  context "connecting with an access_token" do
    before do
      @api = create(:api_key)
      get "/api/v1/users/", nil, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should respond" do
      it { expect(response.status).to eq(200) }
    end
  end

  context "connecting without an access_token" do
    before do
      get "/api/v1/users/"
    end

    describe "should fail" do
      it { expect(response.status).to eq(401) }
    end
  end  
end
