require 'spec_helper'

describe "Users API" do
  
  it 'gets a list of users' do
    @user = create(:user, username:"apitestuser123")
    @api = create(:api_key)
    get "/api/v1/users/", nil, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    expect(response).to eq(200)
    json = JSON.parse(response.body)
    expect(json).to include(@user.username)
  end

end