require 'spec_helper'

describe Api::V1::ListsController do 

  describe "#index" do
    before do
      user = create(:user, password: 'testpass')
      user2 = create(:user)
      open_list = create(:list, user: user, name: 'open_list', permissions: 'open')
      viewable_list = create(:list, user: user, name: 'viewable_list', permissions: 'viewable')
      private_list = create(:list, user: user, name: 'private_list', permissions: 'private')
      open_list2 = create(:list, user: user2, name: 'open_list2', permissions: 'open')
    end

    context "with correct user's password" do
      it "returns all lists associated with the user" do
        params = { lists => {'user_id' => '1', 'password' => 'testpass'}}
        get :index, params

        expect(response).to be_success
        expect(json).to eq(
          { 'lists' => 
            [
              { 'id' => 1, 'name' => 'open_list', 'user_id' => '1', 'permissions' => 'open' },
              { 'id' => 2, 'name' => 'viewable_list', 'user_id' => '1', 'permissions' => 'viewable' },
              { 'id' => 3, 'name' => 'private_list', 'user_id' => '1', 'permissions' => 'private' }
            ]
          }
        )
      end
    end

    context "without correct user's password" do
      it "returns all visible and open lists" do

        params = {list => {'user_id' => '1'}}
        get :index, params

        expect(response).to be_success
        expect(json).to eq(
          { 'lists' => 
            [
              { 'id' => 1, 'name' => 'open_list', 'user_id' => '1', 'permissions' => 'open' },
              { 'id' => 2, 'name' => 'viewable_list', 'user_id' => '1', 'permissions' => 'viewable' }
            ]
          }
        )
      end
    end

    context "for all users" do
      it "returns all visible and open lists" do

        get :index

        expect(response).to be_success
        expect(json).to eq(
          { 'lists' => 
            [
              { 'id' => 1, 'name' => 'open_list', 'user_id' => '1', 'permissions' => 'open' },
              { 'id' => 2, 'name' => 'viewable_list', 'user_id' => '1', 'permissions' => 'viewable' },
              { 'id' => 4, 'name' => 'open_list2', 'user_id' => '2', 'permissions' => 'open' }
            ]
          }
        )
      end
    end
  end

  describe "#create" do
    before do
      user = create(:user, password: 'testpass')
    end

    context "with correct user's password" do
      it "takes a list name, creates it if it doesn't exist, and returns false if it does" do

        params = { 'list' => { 'name' => 'test_list', 'permissions' => 'open', 'password' => 'testpass' }}
        post :create, params

        expect(response).to be_success
        expect(json).to eq(params['list'])
        expect(List.last.name).to eq('test_list')

        post :create, params
        expect(response).to be_error
        expect(List.all.count).to eq 1      
      end
    end

    context "without correct user's password" do
      it "it errors" do
        params = { 'list' => { 'name' => 'test_list', 'permissions' => 'open', 'password' => 'wrongpass' }}
        post :create, params

        expect(response).to be_error
      end
    end

    context "with blank password" do
      it "it errors" do
        params = { 'list' => { 'name' => 'test_list', 'permissions' => 'open' }}
        post :create, params

        expect(response).to be_error
      end
    end

    context "without valid permission" do
      it "it errors" do
        params = { 'list' => { 'name' => 'test_list', 'permissions' => 'wrongperm', 'password' => 'testpass' }}
        post :create, params

        expect(response).to be_error
      end
    end

    context "with blank permission" do
      it "it errors" do
        params = { 'list' => { 'name' => 'test_list', 'password' => 'testpass' }}
        post :create, params

        expect(response).to be_error
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

        params = { 'list' => { 'id' => '1', name => 'new_list_name', 'password' => 'testpass' }}
        put :update, params

        expect(response).to be_success
        expect(List.last.name).to eq('new_list_name')
      end
    end

    context "without correct user's password" do
      it "it errors" do
        params = { 'list' => { 'name' => 'test_list', 'permissions' => 'open', 'password' => 'wrongpass' }}
        put :update, params

        expect(response).to be_error
      end
    end
  end

  describe '#destroy' do
    before do
      @user = create(:user, password: 'testpass')
    end

    it "deletes a list" do
      list = create(:list)
      delete :destroy, id: list.id

      expect( response ).to be_success
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