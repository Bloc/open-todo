require 'spec_helper'

describe Api::V1::UsersController do

  before do
    User.destroy_all
  end

  describe "#create" do
    it "returns a new user from username and password params" do
      params = { 'user' => { 'username' => 'testuser', 'password' => 'testpass' }}
      post :create, params

      expect(response).to be_success
      expect(JSON.parse(response.body)).to eq(params['user'])
      expect(User.size).to eq(1)
    end

    it "returns an error when not given a password" do
      post :create, {user: { username: 'testuser' }}
      expect(response).to be_error
    end

    it "returns an error when not given a username" do
      post :create, {user: { password: 'testpass' }}
      expect(response).to be_error
    end
  end

  describe "#index" do

    before do 
      (1..3).each{ |n| User.create( id: n, username: "name#{n}", password: "pass#{n}" ) }
    end

    it "returns all usernames and ids" do
      get :index

      expect(response).to eq(:success)

      expect(JSON.parse(response.body)).to eq( 
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
end
