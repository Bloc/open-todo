require 'spec_helper'

describe Api::V1::ItemsController do 

  describe "#index" do
    before do
      user = create(:user, password: 'testpass')
      list = create(:list, user: user)
      list2 = create(:list, permission: 'private')
      item = create(:item, description: 'item1', list_id: list.id)
      item2 = create(:item, description: 'item2', list_id: list.id)
      item3 = create(:item, description: 'item3', list_id: list2.id)
    end

    context "with permission for the list" do
      xit "returns all uncompleted items associated with a list" do
        params = {'list' => '1'}
        get :index, params

        expect(response).to be_success
        expect(json).to eq(
          { 'list' => 1
            { 'item' [
              { 'id' => 1, 'description' => 'item1', 'completed' => 'false' },
              { 'id' => 2, 'description' => 'item2', 'completed' => 'false' }
              ]
            }
          }
        )
      end
    end

    context "without permission for the list" do
      xit "returns error" do
        params = {'list' => '2'}
        get :index, params

        expect(response).to be_error
      end
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

    context "when owned by self" do
      xit "an open list takes a description, creates item" do
        params = { 'list' => 1 { 'item' {'description' => 'testitem' }}}
        post :create, params

        expect(response).to be_success
        expect(json).to eq(params['item'])
        expect(Item.last.description).to eq('testitem')    
      end

      xit "a viewable list takes a description, creates item" do
        params = { 'list' => 2 { 'item' {'description' => 'testitem' }}}
        post :create, params

        expect(response).to be_success
        expect(json).to eq(params['item'])
        expect(Item.last.description).to eq('testitem') 
      end

      xit "a private list takes a description, creates item" do
        params = { 'list' => 3 { 'item' {'description' => 'testitem' }}}
        post :create, params

        expect(response).to be_success
        expect(json).to eq(params['item'])
        expect(Item.last.description).to eq('testitem') 
      end
    end

    context "when owned by someone else" do
      xit "an open list takes a description, creates item" do
        params = { 'list' => 4 { 'item' {'description' => 'testitem' }}}
        post :create, params

        expect(response).to be_success
        expect(json).to eq(params['item'])
        expect(Item.last.description).to eq('testitem')    
      end
    
      xit "a viewable list returns an error" do
        params = { 'list' => 5 { 'item' {'description' => 'testitem' }}}
        post :create, params

        expect(response).to be_error
      end

      xit "a private list returns an error" do
        params = { 'list' => 6 { 'item' {'description' => 'testitem' }}}
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
      xit "updates a item description" do
        params = { 'list' => '1' { 'items' {'id' => '1', description => 'newitemname'}} }
        put :update, params

        expect(response).to be_success
        expect(Item.last.name).to eq('newitemname')
      end

      xit "updates a item to be complete" do
        params = { 'list' => '1' { 'items' {'id' => '1', completed => 'true'}]} }
        put :update, params

        expect(response).to be_success
        expect(Item.last.completed).to eq true
      end
    end

    context "without permission for the list" do
      xit "updating a description returns an error" do
        params = { 'list' => '2' { 'items' {'id' => '1', description => 'newitemname'}} }
        put :update, params

        expect(response).to be_error
      end

      xit "updating a completion returns an error" do
        params = { 'list' => '2' { 'items' {'id' => '1', completed => 'true'}} }
        put :update, params

        expect(response).to be_error
      end
    end
  end
end