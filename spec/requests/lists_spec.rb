require 'rails_helper'

describe "List API" do
  context "get /api/v1/lists/" do
    before do
      User.destroy_all
      @api = create(:api_key)
      create_list(:list, 3, permissions: "open")
      create_list(:list, 3, permissions: "viewable")
      create_list(:list, 3, permissions: "private")
      get "/api/v1/lists/", nil, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should show all non-private lists" do
      it { expect(response.status).to eq(200) }
      it { expect(json["lists"]).to be_a_kind_of(Array) }
      it { expect(json["lists"].length).to eq 6 }
    end
  end

  context "get /api/v1/user/id/lists for self" do
    before do
      User.destroy_all
      @user = create(:user)
      @api = create(:api_key, user: @user)
      create_list(:list, 3, permissions: "open", user: @user)
      create_list(:list, 3, permissions: "viewable", user: @user)
      create_list(:list, 3, permissions: "private", user: @user)
      get "/api/v1/users/#{@user.id}/lists", nil, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should show all lists" do
      it { expect(response.status).to eq(200) }
      it { expect(json["lists"]).to be_a_kind_of(Array) }
      it { expect(json["lists"].length).to eq 9 }
    end
  end

  context "get /api/v1/user/id/lists for another" do
    before do
      User.destroy_all
      @user1 = create(:user)
      @api = create(:api_key, user: @user1)
      @user2 = create(:user)
      create_list(:list, 3, permissions: "open", user: @user2)
      create_list(:list, 3, permissions: "viewable", user: @user2)
      create_list(:list, 3, permissions: "private", user: @user2)
      get "/api/v1/users/#{@user2.id}/lists", nil, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should show non-private lists" do
      it { expect(response.status).to eq(200) }
      it { expect(json["lists"]).to be_a_kind_of(Array) }
      it { expect(json["lists"].length).to eq 6 }
    end
  end

  context "post /api/v1/lists/" do
    before do
      User.destroy_all
      List.destroy_all
      @user = create(:user)
      @api = create(:api_key, user: @user)
      post "/api/v1/lists/", {user_id: @user.id, list: {name: 'test_list', permissions: 'open'}}, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should create a list" do
      it { expect(response.status).to eq(200) }
      it { expect(json["list"]["name"]).to include("test_list") }
    end
  end

  context "patch /api/v1/lists/id" do
    before do
      User.destroy_all
      List.destroy_all
      @user = create(:user)
      @api = create(:api_key, user: @user)
      @list = create(:list, permissions: "open", user: @user)
      patch "/api/v1/lists/#{@list.id}", {user_id: @user.id, list: {name: "new_name", permissions: 'private'}}, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should update list name and permissions" do
      it { expect(response.status).to eq(200) }
    end
  end

  context "delete /api/v1/lists/id" do
    before do
      User.destroy_all
      List.destroy_all
      @user = create(:user)
      @api = create(:api_key, user: @user)
      @list = create(:list, permissions: "open", user: @user)
      delete "/api/v1/lists/#{@list.id}", {user_id: @user.id, list: @list.id}, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should delete a list" do
      it { expect(response.status).to eq(200) }
    end
  end
end
