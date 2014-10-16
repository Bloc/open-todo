require 'spec_helper'

describe Api::V1::ItemsController do 

  describe "#index", focus: true do
    before do
      user = create(:user, password: 'testpass')
      list = create(:list, user: user)
      list2 = create(:list, permission: 'private')
      item = create(:item, description: 'item1', list_id: list.id)
      item2 = create(:item, description: 'item2', list_id: list.id)
      item3 = create(:item, description: 'item3', list_id: list2.id)
    end

    context "with permission for the list" do
      it "returns all uncompleted items associated with a list" do
        params = {list_id: "1"}
        get :index, params

        expect(response).to be_success
        expect(json).to eq()
      end
    end

    context "without permission for the list" do
      it "returns error" do
        params = {id: '2'}
        get :index, params

        expect(response).to be_error
      end
    end
  end

  describe "#create" do
    before do
      user = create(:user)
      user2 = create(:user)
      @open_list = create(:list, user: user, permission: 'open')
      @viewable_list = create(:list, user: user, permission: 'viewable')
      @private_list = create(:list, user: user, permission: 'private')
      @open_list2 = create(:list, user: user2, permission: 'open')
      @viewable_list2 = create(:list, user: user2, permission: 'viewable')
      @private_list2 = create(:list, user: user2, permission: 'private')
    end

    context "when owned by self" do
      it "an open list takes a description, creates item" do
        params = { id: @open_list.id, item: {'description' => 'testitem' }}
        post :create, params

        expect(response).to be_success
        expect(json).to eq(params['item'])
        expect(Item.last.description).to eq('testitem')    
      end

      it "a viewable list takes a description, creates item" do
        params = { id: @viewable_list.id, item: {'description' => 'testitem' }}
        post :create, params

        expect(response).to be_success
        expect(json).to eq(params['item'])
        expect(Item.last.description).to eq('testitem') 
      end

      it "a private list takes a description, creates item" do
        params = { id: @private_list.id, item: {'description' => 'testitem' }}
        post :create, params

        expect(response).to be_success
        expect(json).to eq(params['item'])
        expect(Item.last.description).to eq('testitem') 
      end
    end

    context "when owned by someone else" do
      it "an open list takes a description, creates item" do
        params = { id: @open_list2.id, item: {'description' => 'testitem' }}
        post :create, params

        expect(response).to be_success
        expect(json).to eq(params['item'])
        expect(Item.last.description).to eq('testitem')    
      end
    
      it "a viewable list returns an error" do
        params = { id: @viewable_list2.id, item: {'description' => 'testitem' }}
        post :create, params

        expect(response).to be_error
      end

      it "a private list returns an error" do
        params = { id: @private_list2.id, item: {'description' => 'testitem' }}
        post :create, params

        expect(response).to be_error
      end
    end
  end

  describe "#update" do
    before do
      user = create(:user, password: 'testpass')
      list = create(:list, user: user)
      list2 = create(:list, permission: 'private')
      item = create(:item, list_id: list.id)
    end

    context "with permission for the list" do
      it "updates a item description" do
        params = { 'id' => '1', 'items' => {'id' => '1', description => 'newitemname'}} 
        put :update, params

        expect(response).to be_success
        expect(Item.last.name).to eq('newitemname')
      end

      it "updates a item to be complete" do
        params = { 'id' => '1', 'items' => {'id' => '1', completed => 'true'}} 
        put :update, params

        expect(response).to be_success
        expect(Item.last.completed).to eq true
      end
    end

    context "without permission for the list" do
      it "updating a description returns an error" do
        params = { 'id' => '2', 'items' => {'id' => '1', description => 'newitemname'}} 
        put :update, params

        expect(response).to be_error
      end

      it "updating a completion returns an error" do
        params = { 'id' => '2', 'items' => {'id' => '1', completed => 'true'}} 
        put :update, params

        expect(response).to be_error
      end
    end
  end
end