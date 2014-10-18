require 'spec_helper'

describe "Users API" do
  context "#index" do
    before do
      User.destroy_all
      @api = create(:api_key)
      30.times { create(:user) }
      get "/api/v1/users/", nil, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should list all users" do
      it { response.should be_ok }
      it { JSON.parse(response.body)["users"].should be_a_kind_of(Array) }
      it { JSON.parse(response.body)["users"].length.should eq 30 }
    end
  end
end