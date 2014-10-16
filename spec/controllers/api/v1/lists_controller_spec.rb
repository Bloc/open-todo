require 'spec_helper'

describe Api::V1::ListsController do 

  describe "#index" do
    before do
      @user = create(:user, password: 'testpass')
      @api = create(:api_key, user: @user)
      @open_list = create(:list, user: @user, name: 'open_list', permissions: 'open')
      @viewable_list = create(:list, user: @user, name: 'viewable_list', permissions: 'viewable')
      @private_list = create(:list, user: @user, name: 'private_list', permissions: 'private')

      @user2 = create(:user)
      @open_list2 = create(:list, user: @user2, name: 'open_list2', permissions: 'open')
      @viewable_list2 = create(:list, user: @user2, name: 'viewable_list2', permissions: 'viewable')
      @private_list2 = create(:list, user: @user2, name: 'private_list2', permissions: 'private')
    end

    context "authorized user" do
      it "gets all lists for their self" do
        authWithToken(@api.access_token)
        params = { user_id: @user.id, list: {} }
        get :index, params

        expect(response.status).to eq(200) 
        expect(json).to eq(
          { 'lists' => 
            [
              { 'id' => @open_list.id, 'name' => @open_list.name, 'user_id' => @user.id, 'permissions' => @open_list.permissions },
              { 'id' => @viewable_list.id, 'name' => @viewable_list.name, 'user_id' => @user.id, 'permissions' => @viewable_list.permissions },
              { 'id' => @private_list.id, 'name' => @private_list.name, 'user_id' => @user.id, 'permissions' => @private_list.permissions }
            ]
          }
        )
      end
    
      it "gets only visible and open lists for another user" do
        authWithToken(@api.access_token)
        params = { user_id: @user2.id, list: {} }
        get :index, params

        expect(response.status).to eq(200) 
        expect(json).to eq(
          { 'lists' => 
            [
              { 'id' => @open_list2.id, 'name' => @open_list2.name, 'user_id' => @user2.id, 'permissions' => @open_list2.permissions },
              { 'id' => @viewable_list2.id, 'name' => @viewable_list2.name, 'user_id' => @user2.id, 'permissions' => @viewable_list2.permissions }
            ]
          }
        )
      end

      it "gets error for invalid user" do
        authWithToken(@api.access_token)
        params = { user_id: "100", list: {} }
        get :index, params

        expect(response.status).to eq(400) 
      end
    end

    context "when handling all users" do
      it "returns all visible and open lists" do
        authWithToken(@api.access_token)
        get :index

        expect(response.status).to eq(200)
        expect(json).to eq(
          { 'lists' => 
            [
              { 'id' => @open_list.id, 'name' => @open_list.name, 'user_id' => @user.id, 'permissions' => @open_list.permissions },
              { 'id' => @viewable_list.id, 'name' => @viewable_list.name, 'user_id' => @user.id, 'permissions' => @viewable_list.permissions },
              { 'id' => @open_list2.id, 'name' => @open_list2.name, 'user_id' => @user2.id, 'permissions' => @open_list2.permissions },
              { 'id' => @viewable_list2.id, 'name' => @viewable_list2.name, 'user_id' => @user2.id, 'permissions' => @viewable_list2.permissions }
            ]
          }
        )
      end
    end

    after do
      clearToken
    end
  end

  describe "#create" do
    before do
      @user = create(:user, password: 'testpass')
      @api = create(:api_key, user: @user)
      authWithToken(@api.access_token)
    end

    it "takes a list name, creates it if it doesn't exist, and returns false if it does" do
      params = { user_id: @user.id, list: {name: 'test_list', permissions: 'open'}}
      post :create, params
      last_list = List.last

      expect(response.status).to eq(200) 
      expect(json).to eq({"list"=>{"id"=>last_list.id, "name"=>last_list.name, "user_id"=>last_list.user_id, "permissions"=>last_list.permissions}})
      expect(last_list.name).to eq('test_list')

      post :create, params
      expect(response.status).to eq(422)
      expect(List.all.count).to eq 1      
    end

    
    it "fails without a valid permission type" do
      params = { user_id: @user.id, list: { name: 'test_list', permissions: 'wrongperm'}}
      post :create, params

      expect(response.status).to eq(422) 
    end
    
    it "fails with blank permission" do
      params = { user_id: @user.id, list: {name: 'test_list', permissions: ''}}  #create is successful though if permission symbol is omitted
      post :create, params

      expect(response.status).to eq(422) 
    end

    after do
      clearToken
    end
  end

  describe "#update" do
    before do
      @user = create(:user, password: 'testpass')
      @api = create(:api_key, user: @user)
      authWithToken(@api.access_token)
    end

    it "updates a list name that belongs to the authorized user" do
      @list = create(:list, user: @user)
      params = { user_id: @user.id, id: @list.id, list: {name: 'new_list_name'}}
      patch :update, params

      expect(response.status).to eq(200) 
      expect(List.last.name).to eq('new_list_name')
    end


    it "fails to update a list that belongs to another user" do
      other_user = create(:user)
      other_list = create(:list, user: other_user, name: 'original_name')
      params = { user_id: other_user.id, id: other_list.id, list: {name: 'other_list_name'}}
      patch :update, params

      expect(response.status).to eq(401) 
      expect(List.last.name).to eq('original_name')
    end

    it "fails to update an invalid list" do
      params = { user_id: @user.id, id: "100", list: {name: 'new_list_name'}}
      patch :update, params

      expect(response.status).to eq(400) 
    end

    after do
      clearToken
    end
  end

  describe '#destroy' do
    before do
      @user = create(:user, password: 'testpass')
      @api = create(:api_key, user: @user)
      authWithToken(@api.access_token)
    end

    it "deletes a list that belongs to the authorized user" do
      list = create(:list, user_id: @user.id)
      params = {user_id: @user.id, id: list.id}
      delete :destroy, params

      expect(response.status).to eq(200) 
      expect( List.count ).to eq(0)
    end

    it "fails to delete another user's list" do
      other_user = create(:user)
      other_list = create(:list, user: other_user)
      params = {user_id: @user.id, id: other_list.id}
      delete :destroy, params
      
      expect( List.count ).to eq(1)
      expect(response.status).to eq(401) 
    end

    it "fails to delete an invalid list" do
      params = {user_id: @user.id, id: "100"}
      delete :destroy, params

      expect(response.status).to eq(400)
    end

    after do
      clearToken
    end
  end
end