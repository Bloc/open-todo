require 'spec_helper'

describe Api::V1::ListsController do 

  describe "#index" do
    before do
      @user = create(:user, password: 'testpass')
      @api = create(:api_key, user: @user)
      @user2 = create(:user)
      @api2 = create(:api_key, user: @user2)
      @open_list = create(:list, user: @user, name: 'open_list', permissions: 'open')
      @viewable_list = create(:list, user: @user, name: 'viewable_list', permissions: 'viewable')
      @private_list = create(:list, user: @user, name: 'private_list', permissions: 'private')
      @open_list2 = create(:list, user: @user2, name: 'open_list2', permissions: 'open')
    end

    context "with correct user's password" do
      it "returns all lists associated with the user" do
        authWithToken(@api.access_token)
        params = { user_id: @user.id, list: {password: @user.password} }
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
    end

    context "without correct user's password" do
      it "returns only visible and open lists" do
        authWithToken(@api.access_token)
        params = { user_id: @user.id, list: {} }
        get :index, params

        expect(response.status).to eq(200) 
        expect(json).to eq(
          { 'lists' => 
            [
              { 'id' => @open_list.id, 'name' => @open_list.name, 'user_id' => @user.id, 'permissions' => @open_list.permissions },
              { 'id' => @viewable_list.id, 'name' => @viewable_list.name, 'user_id' => @user.id, 'permissions' => @viewable_list.permissions }
            ]
          }
        )
      end
    end

    context "for all users" do
      xit "returns all visible and open lists" do
        authWithToken(@api.access_token)
        get :index

        expect(response.status).to eq(200)
        expect(json).to eq(
          { 'lists' => 
            [
              { 'id' => @open_list.id, 'name' => @open_list.name, 'user_id' => @user.id, 'permissions' => @open_list.permissions },
              { 'id' => @viewable_list.id, 'name' => @viewable_list.name, 'user_id' => @user.id, 'permissions' => @viewable_list.permissions },
              { 'id' => @open_list2.id, 'name' => @open_list.name, 'user_id' => @user2.id, 'permissions' => @open_list.permissions }
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

    context "with correct user's password" do
      it "takes a list name, creates it if it doesn't exist, and returns false if it does" do
        params = { user_id: @user.id, list: {name: 'test_list', permissions: 'open', password: @user.password}}
        post :create, params
        last_list = List.last

        expect(response.status).to eq(200) 
        expect(json).to eq({"list"=>{"id"=>last_list.id, "name"=>last_list.name, "user_id"=>last_list.user_id, "permissions"=>last_list.permissions}})
        expect(last_list.name).to eq('test_list')

        post :create, params
        expect(response.status).to eq(422)
        expect(List.all.count).to eq 1      
      end
    end

    context "without correct user's password" do
      it "it errors" do
        params = { user_id: @user.id, list: { name: 'test_list', permissions: 'open', password: 'wrongpass' }}
        post :create, params

        expect(response.status).to eq(422) 
      end
    end

    context "with blank password" do
      it "it errors" do
        params = { user_id: @user.id, list: { name: 'test_list', permissions: 'open' }}
        post :create, params

        expect(response.status).to eq(422) 
      end
    end

    context "without valid permission" do
      it "it errors" do
        params = { user_id: @user.id, list: { name: 'test_list', permissions: 'wrongperm', password: @user.password }}
        post :create, params

        expect(response.status).to eq(422) 
      end
    end

    context "with blank permission" do
      it "it errors" do
        params = { user_id: @user.id, list: { name: 'test_list', password: @user.password }}
        post :create, params

        expect(response.status).to eq(422) 
      end
    end

    after do
      clearToken
    end
  end

  describe "#update", focus: true do
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

    after do
      clearToken
    end
  end
end