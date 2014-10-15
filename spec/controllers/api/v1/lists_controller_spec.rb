require 'spec_helper'

describe Api::V1::ListsController do 

  describe "#index" do
    before do
      @user = create(:user, password: 'testpass')
      @user2 = create(:user)
      @open_list = create(:list, user: @user, name: 'open_list', permissions: 'open')
      @viewable_list = create(:list, user: @user, name: 'viewable_list', permissions: 'viewable')
      @private_list = create(:list, user: @user, name: 'private_list', permissions: 'private')
      @open_list2 = create(:list, user: @user2, name: 'open_list2', permissions: 'open')
    end

    context "with correct user's password" do
      it "returns all lists associated with the user" do
        params = { user_id: @user.id, list: { password: 'testpass'}}
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

        params = { user_id: @user.id, list: {}}
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
  end

  describe "#create" do
    before do
      @user = create(:user, password: 'testpass')
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
  end

  describe "#update" do
    before do
      @user = create(:user, password: 'testpass')
      @list = create(:list, user: @user)
    end

    context "with correct user's password" do
      it "updates a list name" do

        params = { user_id: @user.id, list_id: @list.id, list: {name: 'new_list_name', password: @user.password }}
        patch :update, params

        expect(response.status).to eq(200) 
        expect(List.last.name).to eq('new_list_name')
      end
    end

    context "without correct user's password" do
      it "it errors" do
        params = { user_id: @user.id, list_id: @list.id, list: { name: @list.name, permissions: @list.permissions, password: 'wrongpass' }}
        patch :update, params

        expect(response.status).to eq(400) 
      end
    end
  end

  describe '#destroy' do
    before do
      @user = create(:user, password: 'testpass')
    end

    it "deletes a list", focus: true do
      list = create(:list)
      params = {user_id: @user.id, list: {id: list.id, password: @user.password}}
      delete :destroy, params

      expect(response.status).to eq(200) 
      expect( List.count ).to eq(0)
    end

    it "fails to delete another user's list" do
      other_user = create(:user)
      list = create(:list, user: other_user)

      assert_raises(ActiveRecord::RecordNotFound) do
        delete :destroy, id: list.id
      end

      list.reload
      expect(assigns(:list)).to be_nil
    end
  end
end