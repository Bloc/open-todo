require 'rails_helper'

describe "Users API" do
  context "get /api/v1/users/" do
    before do
      User.destroy_all
      @api = create(:api_key)
      3.times { create(:user) }
      get "/api/v1/users/", nil, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should list all users" do
      it { expect(response.status).to eq(200) }
      it { expect(json["users"]).to be_a_kind_of(Array) }
      it { expect(json["users"].length).to eq 3 }
    end
  end

  context "post /api/v1/users/ with username and password" do
    before do
      User.destroy_all
      @api = create(:api_key)
      post "/api/v1/users/", {user: {username: 'testuser', password: 'testpass'}}, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should create a new user" do
      it { expect(response.status).to eq(200) }
      it { expect(json["user"]).to eq({"id"=>User.last.id, "username"=>"testuser"}) }
    end
  end

  context "post /api/v1/users/ with nonunique username" do
    before do
      User.destroy_all
      @api = create(:api_key)
      post "/api/v1/users/", {user: {username: 'testuser', password: 'testpass'}}, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
      post "/api/v1/users/", {user: {username: 'testuser', password: 'testpass'}}, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should fail" do
      it { expect(response.status).to eq(422) }
      it { expect(response.body).to include("username") }
      it { expect(response.body).to include("taken") }
    end
  end

  context "post /api/v1/users/ without a username" do
    before do
      User.destroy_all
      @api = create(:api_key)
      post "/api/v1/users/", {user: {password: 'testpass'}}, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should fail" do
      it { expect(response.status).to eq(422) }
      it { expect(response.body).to include("username") }
      it { expect(response.body).to include("blank") }
    end
  end

  context "post /api/v1/users/ without a password" do
    before do
      User.destroy_all
      @api = create(:api_key)
      post "/api/v1/users/", {user: {username: 'testuser'}}, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should fail" do
      it { expect(response.status).to eq(422) }
      it { expect(response.body).to include("password") }
      it { expect(response.body).to include("blank") }
    end
  end
end
