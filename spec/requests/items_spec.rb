require 'spec_helper'

describe "Items API" do

  context "get /api/v1/lists/id" do
    before do
      User.destroy_all
      @user = create(:user)
      @api = create(:api_key, user: @user)
      @list = create(:list, permissions: "open", user: @user)
      create_list(:item, 3, list_id: @list.id, completed: false)
      create(:item, list_id: @list.id, completed: true)
      get "/api/v1/lists/#{@list.id}", nil, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should show all uncompleted items" do
      it { expect(response.status).to eq(200) }
      it { json["list"]["items"].should be_a_kind_of(Array) }
      it { json["list"]["items"].length.should eq 3 }
    end
  end

  context "post /api/v1/lists/id" do
    before do
      User.destroy_all
      @user = create(:user)
      @api = create(:api_key, user: @user)
      @list = create(:list, permissions: "open", user: @user)
      create_list(:item, 3, list_id: @list.id, completed: false)
      create(:item, list_id: @list.id, completed: true)
      get "/api/v1/lists/#{@list.id}", nil, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should create a new item" do
      it { expect(response.status).to eq(200) }
      it { json["list"]["items"].should be_a_kind_of(Array) }
      it { json["list"]["items"].length.should eq 3 }
    end
  end

  context "delete /api/v1/lists/id" do
    before do
      User.destroy_all
      @user = create(:user)
      @api = create(:api_key, user: @user)
      @list = create(:list, permissions: "open", user: @user)
      create_list(:item, 3, list_id: @list.id, completed: false)
      create(:item, list_id: @list.id, completed: true)
      get "/api/v1/lists/#{@list.id}", nil, {'X-ACCESS-TOKEN' => "#{@api.access_token}"}
    end

    describe "should mark item complete" do
      it { expect(response.status).to eq(200) }
      it { json["list"]["items"].should be_a_kind_of(Array) }
      it { json["list"]["items"].length.should eq 3 }
    end
  end

end