require 'spec_helper'

describe Api::V1::ItemsController do 

  describe "#index" do
    before do
      user = create(:user, password: 'testpass')
      list = create(:list, user: user)
      list2 = create(:list, permission: 'private')
      item = create(:item, description: 'item1', list: list)
      item2 = create(:item, description: 'item2', list: list)
      item3 = create(:item, description: 'item3', list: list2)
    
    end

    context "with permission for the list" do
      xit "returns all uncompleted items associated with a list"
      params = {'list' => '1'}
      get :index, params

      expect(response).to be_success
      expect(json).to eq(
        { 'list' => 1
          { 'item' => [
            { 'id' => 1, 'description' => 'item1', 'completed' => 'false' },
            { 'id' => 2, 'description' => 'item2', 'completed' => 'false' }
          ]
        }
      )
    end

    context "without permission for the list" do
      xit "returns error"
      params = {'list' => '2'}
      get :index, params

      expect(response).to be_error
    end
  end

  describe "#create" do
    before do
      user = create(:user)
      user2 = create(:user)
      openlist = create(:list, user: user, permission: 'open')
      viewablelist = create(:list, user: user, permission: 'viewable')
      privatelist = create(:list, user: user, permission: 'private')
      openlist2 = create(:list, user: user2, permission: 'open')
      viewablelist2 = create(:list, user: user2, permission: 'viewable')
      privatelist2 = create(:list, user: user2, permission: 'private')
    end

    context "for an open list owned by self" do
      xit "takes a description, creates item"

      params = { 'list' => 1 { 'item' => {'description' => 'testitem' }}}
      post :create, params

      expect(response).to be_success
      expect(json).to eq(params['item'])
      expect(Item.last.description).to eq('testitem')    
    end

    context "for a viewable list owned by self" do
      xit "takes a description, creates item"
      params = { 'list' => 2 { 'item' => {'description' => 'testitem' }}}
      post :create, params

      expect(response).to be_success
      expect(json).to eq(params['item'])
      expect(Item.last.description).to eq('testitem') 
    end

    context "for a private list owned by self" do
      xit "takes a description, creates item"
      params = { 'list' => 3 { 'item' => {'description' => 'testitem' }}}
      post :create, params

      expect(response).to be_success
      expect(json).to eq(params['item'])
      expect(Item.last.description).to eq('testitem') 
    end

    context "for an open list owned by someone else" do
      xit "takes a description, creates item"

      params = { 'list' => 4 { 'item' => {'description' => 'testitem' }}}
      post :create, params

      expect(response).to be_success
      expect(json).to eq(params['item'])
      expect(Item.last.description).to eq('testitem')    
    end

    context "for a viewable list owned by someone else" do
      xit "it errors"
      params = { 'list' => 5 { 'item' => {'description' => 'testitem' }}}
      post :create, params

      expect(response).to be_error
    end

    context "for a private list owned by someone else" do
      xit "it errors"
      params = { 'list' => 6 { 'item' => {'description' => 'testitem' }}}
      post :create, params

      expect(response).to be_error
    end
  end

  describe "#update" do
    before do
      user = create(:user, password: 'testpass')
      list = create(:list, user: @user)
      list2 = create(:list, permission: 'private')
      item = create(:item, list: @list)
    end

    context "with permission for the list" do
      xit "updates a item description"

      params = { 'list' => '1' { 'task' => {'id' => '1', description => 'newitemname'}} }
      put :update, params

      expect(response).to be_success
      expect(Item.last.name).to eq('newitemname')
    end

    context "with permission for the list" do
      xit "updates a item to be complete"

      params = { 'list' => '1' { 'task' => {'id' => '1', completed => 'true'}} }
      put :update, params

      expect(response).to be_success
      expect(Item.last.completed).to eq true
    end

    context "without permission for the list" do
      xit "updating a description errors"
      params = { 'list' => '2' { 'task' => {'id' => '1', description => 'newitemname'}} }
      put :update, params

      expect(response).to be_error
    end

    context "without permission for the list" do
      xit "updating a completion errors"
      params = { 'list' => '2' { 'task' => {'id' => '1', completed => 'true'}} }
      put :update, params

      expect(response).to be_error
    end
  end
end