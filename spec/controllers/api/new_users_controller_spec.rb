require 'spec_helper'

describe Api::UsersController do

  before do
    User.destroy_all
  end

  describe "create" do
    it "creates and returns a new user from username and password params" do
      params = { 'new_user' => { 'username' => 'testuser', 'password' => 'testpass' } }

      expect{ post :create, params }
        .to change{ User.where(params['new_user']).count }
        .by 1

      JSON.parse(response.body).should == params['new_user']
    end

    it "returns an error when not given a password" do
      post :create, { username: 'testuser' }
      response.should be_error
    end

    it "returns an error when not given a username" do
      post :create, { password: 'testpass' }
      response.should be_error
    end
  end

  describe "index" do

    before do 
      (1..3).each{ |n| User.create( id: n, username: "name#{n}", password: "pass#{n}" ) }
    end

    it "lists all usernames and ids" do
      get :index

      JSON.parse(response.body).should == 
        { 'users' => 
          [
            { 'id' => 1, 'username' => 'name1' },
            { 'id' => 2, 'username' => 'name2' },
            { 'id' => 3, 'username' => 'name3' }
          ]
        }
    end
  end
end
