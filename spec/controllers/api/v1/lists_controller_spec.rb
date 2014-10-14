require 'spec_helper'

describe Api::V1::ListsController do 

  describe "#index" do
    before do
      user = create(:user, password: 'testpass')
      user2 = create(:user)
      openlist = create(:list, user: user, name: 'openlist', permissions: 'open')
      viewablelist = create(:list, user: user, name: 'viewablelist', permissions: 'viewable')
      privatelist = create(:list, user: user, name: 'privatelist', permissions: 'private')
      openlist2 = create(:list, user: user2, name: 'openlist', permissions: 'open')
    end

    context "with correct user's password" do
      xit "returns all lists associated with the user"
      params = {'user' => '1', 'password' => 'testpass'}
      get :index, params

      expect(response).to be_success
      expect(json).to eq(
        { 'lists' => 
          [
            { 'id' => 1, 'name' => 'openlist', 'user' => '1', 'permissions' => 'open' },
            { 'id' => 2, 'name' => 'viewablelist', 'user' => '1', 'permissions' => 'viewable' },
            { 'id' => 3, 'name' => 'privatelist', 'user' => '1', 'permissions' => 'private' }
          ]
        }
      )
    end

    context "without correct user's password" do
      xit "returns all visible and open lists"

      params = {'user' => '1'}
      get :index, params

      expect(response).to be_success
      expect(json).to eq(
        { 'lists' => 
          [
            { 'id' => 1, 'name' => 'openlist', 'user' => '1', 'permissions' => 'open' },
            { 'id' => 2, 'name' => 'viewablelist', 'user' => '1', 'permissions' => 'viewable' }
          ]
        }
      )
    end

    context "for all users" do
      xit "returns all visible and open lists"

      get :index

      expect(response).to be_success
      expect(json).to eq(
        { 'lists' => 
          [
            { 'id' => 1, 'name' => 'openlist', 'user' => '1', 'permissions' => 'open' },
            { 'id' => 2, 'name' => 'viewablelist', 'user' => '1', 'permissions' => 'viewable' }
          ]
        }
      )
    end
  end

  describe "#create" do
    before do
      user = create(:user, password: 'testpass')
    end

    context "with correct user's password" do
      xit "takes a list name, creates it if it doesn't exist, and returns false if it does"

      params = { 'list' => { 'name' => 'testlist', 'permissions' => 'open', 'password' => 'testpass' }}
      post :create, params

      expect(response).to be_success
      expect(json).to eq(params['list'])
      expect(List.last.name).to eq('testlist')

      post :create, params
      expect(response).to be_error
      expect(List.all.count).to eq 1      
    end

    context "without correct user's password" do
      xit "it errors"
      params = { 'list' => { 'name' => 'testlist', 'permissions' => 'open', 'password' => 'wrongpass' }}
      post :create, params

      expect(response).to be_error
    end

    context "with blank password" do
      xit "it errors"
      params = { 'list' => { 'name' => 'testlist', 'permissions' => 'open' }}
      post :create, params

      expect(response).to be_error
    end

    context "without valid permission" do
      xit "it errors"
      params = { 'list' => { 'name' => 'testlist', 'permissions' => 'wrongperm', 'password' => 'testpass' }}
      post :create, params

      expect(response).to be_error
    end

    context "with blank permission" do
      xit "it errors"
      params = { 'list' => { 'name' => 'testlist', 'password' => 'testpass' }}
      post :create, params

      expect(response).to be_error
    end
  end

  describe "#update" do
    before do
      @user = create(:user, password: 'testpass')
      @list = create(:list, user: @user)
    end

    context "with correct user's password" do
      xit "updates a list name"

      params = { 'list' => { 'id' => '1', name => 'newlistname', 'password' => 'testpass' }}
      put :update, params

      expect(response).to be_success
      expect(@list.name).to eq('newlistname')
    end

    context "without correct user's password" do
      xit "it errors"
      params = { 'list' => { 'name' => 'testlist', 'permissions' => 'open', 'password' => 'wrongpass' }}
      post :create, params

      expect(response).to be_error
    end
  end

  describe '#destroy' do

    before do
      @user = create(:user, password: 'testpass')
    end

    xit "deletes a list" do
      list = create(:list, user: @user)
      delete :destroy, id: list.id

      expect( response ).to be_success
      expect( List.count ).to eq(0)
    end

    xit "fails to delete another user's list" do
      other_user = create(:user)
      list = create(:list, user: other_user)

      assert_raises(ActiveRecord::RecordNotFound) do
        delete :destroy, id: list.id
      end

      task.reload
      expect(assigns(:list)).to be_nil
    end
  end

end