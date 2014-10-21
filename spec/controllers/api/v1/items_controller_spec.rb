require 'rails_helper'

describe Api::V1::ItemsController do 

  describe "#create" do
    before do
      @user = create(:user)
      @api = create(:api_key, user: @user)
      @user2 = create(:user)
      @open_list = create(:list, user: @user, permissions: 'open')
      @viewable_list = create(:list, user: @user, permissions: 'viewable')
      @private_list = create(:list, user: @user, permissions: 'private')
      @open_list2 = create(:list, user: @user2, permissions: 'open')
      @viewable_list2 = create(:list, user: @user2, permissions: 'viewable')
      @private_list2 = create(:list, user: @user2, permissions: 'private')

      authWithToken(@api.access_token)
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

        expect(response.status).to eq(422)
      end

      it "a private list returns an error" do
        params = { list_id: @private_list2.id, item: {description: 'testitem' }}
        post :create, params

        expect(response.status).to eq(422)
      end
    end

    after do
      clearToken
    end
  end

  describe "#update" do
    before do
      @user = create(:user)
      @api = create(:api_key, user: @user)
      @open_list = create(:list, user_id: @user.id, permissions: 'private')
      @item = create(:item, list_id: @open_list.id)
      @private_list = create(:list, permissions: 'private')
      @item2 = create(:item, list_id: @private_list.id)

      authWithToken(@api.access_token)
    end

    context "when the authorized user owns the list" do
      it "updates a item description" do
        params = { list_id: @open_list.id, id: @item.id, item: {description: 'newitemname'}} 
        patch :update, params

        expect(response.status).to eq(200)
        @item.reload
        expect(@item.description).to eq('newitemname')
      end

      it "updates a item to be complete" do
        params = { list_id: @open_list.id, id: @item.id, item: {completed: 'true'}} 
        patch :update, params

        expect(response.status).to eq(200)
        @item.reload
        expect(@item.completed).to eq true
      end
    end

    context "when the authorized user does not own the list" do
      it "updating a description returns an error" do
        params = { list_id: @private_list.id, id: @item2.id, item: {description: 'newitemname'}} 
        patch :update, params

        expect(response.status).to eq(422)
      end

      it "updating a completion returns an error" do
        params = { list_id: @private_list.id, id: @item2.id, item: {completed: 'true'}} 
        patch :update, params

        expect(response.status).to eq(422)
      end
    end

    after do
      clearToken
    end
  end

  describe "#destroy" do
    before do
      @user = create(:user)
      @api = create(:api_key, user: @user)
      @open_list = create(:list, user_id: @user.id, permissions: 'open')
      @private_list = create(:list, permissions: 'private')
      @item = create(:item, list_id: @open_list.id, completed: 'false')
      @private_item = create(:item, list_id: @private_list.id,  completed: 'false')

      authWithToken(@api.access_token)
    end

    context "when the authorized user owns the list" do
      it "updates a item to be complete" do
        params = { id: @item.id }
        delete :destroy, params

        expect(response.status).to eq(200)
        @item.reload
        expect(@item.completed).to eq true
      end
    end

    context "when the authorized user does not own the list" do
      it "returns an error" do
        params = { id: @private_item.id }
        delete :destroy, params

        expect(response.status).to eq(401)
        @private_item.reload
        expect(@private_item.completed).to eq false
      end
    end

    after do
      clearToken
    end
  end
end
