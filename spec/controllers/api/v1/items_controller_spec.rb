require 'spec_helper'

describe Api::V1::ItemsController do 

  describe "#create" do
    before do
      user = create(:user)
      user2 = create(:user)
      @open_list = create(:list, user: user, permissions: 'open')
      @viewable_list = create(:list, user: user, permissions: 'viewable')
      @private_list = create(:list, user: user, permissions: 'private')
      @open_list2 = create(:list, user: user2, permissions: 'open')
      @viewable_list2 = create(:list, user: user2, permissions: 'viewable')
      @private_list2 = create(:list, user: user2, permissions: 'private')
    end

    context "when owned by self" do
      it "an open list takes a description, creates item" do
        params = { list_id: @open_list.id, item: {description: 'testitem' }}
        post :create, params

        expect(response.status).to eq(200)
        expect(Item.last.description).to eq('testitem')    
      end

      it "a viewable list takes a description, creates item" do
        params = { list_id: @viewable_list.id, item: {description: 'testitem' }}
        post :create, params

        expect(response.status).to eq(200)
        expect(Item.last.description).to eq('testitem') 
      end

      it "a private list takes a description, creates item" do
        params = { list_id: @private_list.id, item: {description: 'testitem' }}
        post :create, params

        expect(response.status).to eq(200)
        expect(Item.last.description).to eq('testitem') 
      end
    end

    context "when owned by someone else" do
      it "an open list takes a description, creates item" do
        params = { list_id: @open_list2.id, item: {description: 'testitem' }}
        post :create, params

        expect(response.status).to eq(200)
        expect(Item.last.description).to eq('testitem')    
      end
    
      it "a viewable list returns an error" do
        params = { list_id: @viewable_list2.id, item: {description: 'testitem' }}
        post :create, params

        expect(response.status).to eq(400)
      end

      it "a private list returns an error" do
        params = { list_id: @private_list2.id, item: {description: 'testitem' }}
        post :create, params

        expect(response.status).to eq(400)
      end
    end
  end

  describe "#update" do
    before do
      @user = create(:user, password: 'testpass')
      @open_list = create(:list, user_id: @user.id, permissions: 'private')
      @private_list = create(:list, permissions: 'private')
      @item = create(:item, list_id: @open_list.id)
    end

    context "with permission for the list" do
      it "updates a item description" do
        params = { list_id: @open_list.id, items: {id: @item.id, description: 'newitemname'}} 
        put :update, params

        expect(response.status).to eq(200)
        expect(Item.last.name).to eq('newitemname')
      end

      it "updates a item to be complete" do
        params = { list_id: @open_list.id, items: {id: @item.id, completed: 'true'}} 
        put :update, params

        expect(response.status).to eq(200)
        expect(Item.last.completed).to eq true
      end
    end

    context "without permission for the list" do
      it "updating a description returns an error" do
        params = { list_id: @private_list.id, items: {id: @item.id, description: 'newitemname'}} 
        put :update, params

        expect(response.status).to eq(400)
      end

      it "updating a completion returns an error" do
        params = { list_id: @private_list.id, items: {id: @item.id, completed: 'true'}} 
        put :update, params

        expect(response.status).to eq(400)
      end
    end
  end

  describe "#destroy" do
    before do
      @user = create(:user, password: 'testpass')
      @open_list = create(:list, user_id: @user.id, permissions: 'open')
      @private_list = create(:list, permissions: 'private')
      @item = create(:item, list_id: @open_list.id, completed: 'false')
      @private_item = create(:item, list_id: @private_list.id,  completed: 'false')
    end

    context "with permission for the list" do
      it "updates a item to be complete" do
        params = { id: @item.id }
        delete :destroy, params

        expect(response.status).to eq(200)
        puts @item.completed
        expect(@item.completed).to eq true
      end
    end

    context "without permission for the list" do
      it "returns an error" do
        params = { id: @private_item.id }
        delete :destroy, params

        expect(response.status).to eq(400)
        expect(@private_item.completed).to eq false
      end
    end
  end
end