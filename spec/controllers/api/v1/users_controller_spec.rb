require 'rails_helper'

describe Api::V1::UsersController do

  before do
    User.destroy_all
    @api = create(:api_key)
    authWithToken(@api.access_token)
  end

  describe "#create" do
    it "returns a new user from username and password params" do
      params = { user: { username: 'testuser', password: 'testpass' }}
      post :create, params
      last_user = User.last

      expect(response.status).to eq(200) 
      expect(json).to eq({"user"=>{"id"=>last_user.id, "username"=>last_user.username}})
      expect(User.last.username).to eq(last_user.username)
    end

    it "returns an error when not given a password" do
      post :create, { user: { username: 'testuser' }}

      expect(response.status).to eq(422)
      expect(response.body).to include("password")
      expect(response.body).to include("blank")
    end

    it "returns an error when not given a username" do
      post :create, { user: { password: 'testpass' }}
      
      expect(response.status).to eq(422)
      expect(response.body).to include("username")
      expect(response.body).to include("blank")
    end
  end

  describe "#index" do
    before do 
      (1..3).each{ |n| User.create( id: n, username: "name#{n}", password: "pass#{n}" ) }
    end

    it "returns all usernames and ids" do
      get :index

      expect(response).to be_success
      expect(json).to eq( 
        { 'users' => 
          [
            { 'id' => 1, 'username' => 'name1' },
            { 'id' => 2, 'username' => 'name2' },
            { 'id' => 3, 'username' => 'name3' }
          ]
        }
      )
    end
  end

  after do
    clearToken
  end
end
