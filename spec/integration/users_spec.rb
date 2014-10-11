require 'spec_helper'
require 'rest_client'

describe "Users API" do

  before do
    @api_url = ""
  end

  it 'gets a list of users' do
    user = create(:user)

    #response = RestClient.get "http://0.0.0.0:3000/api/v1/users"
    #using this means I have to really start the app and will be testing against it.

    response = get "/api/v1/users"
    puts response
    expect(response).to eq(200)
    json = JSON.parse(response.body)
    expect(json).to include(user.username)
  end
end