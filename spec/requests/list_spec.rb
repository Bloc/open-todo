require 'spec_helper'

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
      it { json["lists"].should be_a_kind_of(Array) }
      it { json["lists"].length.should eq 6 }
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
      it { json["lists"].should be_a_kind_of(Array) }
      it { json["lists"].length.should eq 9 }
    end
  end

  context "get /api/v1/user/id/lists for other" do
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
      it { json["lists"].should be_a_kind_of(Array) }
      it { json["lists"].length.should eq 6 }
    end
  end
end