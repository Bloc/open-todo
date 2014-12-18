require 'spec_helper'

describe Api::ItemsController do

  before do
    User.destroy_all
    List.destroy_all
    @user = create(:user)
  end

  describe "create" do
      before do
        @list = @user.lists.create(name: 'newlist', permissions: 'open')
      end

    context "with correct user's password" do
      it "create an item for a particular list" do
        expect(Item.count).to eq(0)
        params = { user_id: @user.id, password: @user.password, list_id: @list.id, item: {description: 'test_item'} }
        post :create, params
        expect(Item.count).to eq(1)
        JSON.parse(response.body).should ==
        { 'item' =>
          { 'description' => 'test_item', 'list_id' => @list.id, 'completed' => false }
        }
      end
    end


    context "without correct user's password" do
      it "it errors" do
        params = { user_id: @user.id, password:'wrongpassword', list_id: @list.id, item: {description: 'test_item'} }
        post :create, params
        expect(response.status).to eq(401)
      end
    end
  end

  describe "index" do

    before do
      @user1 = create(:user)
      @list= @user.lists.create(name: "openlist", permissions: 'open' )
      firstItem = @list.items.create(description: 'firstItem', completed: 'false')
      secondItem = @list.items.create(description: 'secondItem', completed: 'false')
      thirdItem = @list.items.create(description: 'thirdItem', completed: 'false')
      @privatelist= @user.lists.create(name: "privatelist", permissions: 'private' )
      firstprivateItem = @privatelist.items.create(description: 'firstprivateItem', completed: 'false')
    end

    context "with correct user's password" do
      it "returns all items associated with a list" do
        params = { user_id: @user.id, password: @user.password, list_id: @list.id}
        get :index, params

        JSON.parse(response.body).should ==
        { 'items' =>
          [
            { 'description' => 'firstItem', 'list_id' => @list.id, 'completed' => false },
            { 'description' => 'secondItem', 'list_id' => @list.id, 'completed' => false},
            { 'description' => 'thirdItem', 'list_id' => @list.id, 'completed' => false },
            { 'description' => 'firstprivateItem', 'list_id' => @privatelist.id, 'completed' => false }
          ]
        }
      end
    end

    context "without correct user's password" do
      it "returns all items if list is visible or open" do

      end

    end


end

    describe "#Update" do
      before do
        @openList= @user.lists.create(name: "openlist", permissions: 'open' )
        @firstItem = @openList.items.create(description: "firstItem")
      end

      context "with correct user's password" do
        it "change item's description" do
          expect(@firstItem.completed).to eq(false)
          expect(@openList.items.count).to eq 1

          # change item completion
          params = {user_id: @user.id, password: @user.password, list_id: @openList.id, id: @firstItem.id, item: {description: 'NotfirstItem'}}
          put :update, params

          # check to see if the the new permission has changed.
          JSON.parse(response.body).should ==
          { 'item' =>
            { 'description' => 'NotfirstItem', 'list_id' => @openList.id, 'completed' => false }
          }
        end

        it "change an item to complete" do
          # change item completion
          params = {user_id: @user.id, password: @user.password, list_id: @openList.id, id:@firstItem.id, item: {completed: 'true'}}
          put :update, params

          # Test to see if the item has been removed from the list.
          JSON.parse(response.body).should ==
          { 'item' =>
            { 'description' => 'firstItem', 'list_id' => @openList.id, 'completed' => true }
          }

        end


        it "edit an item if an item is marked open" do
          expect(@firstItem.description).to eq('firstItem')

          # change item completion
          params = {user_id: @user.id, password: @user.password, list_id: @openList.id, id: @firstItem.id, item: {description: 'NotfirstItem'}}
          put :update, params
          response.body.inspect

          # check to see if the the new permission has changed.
          JSON.parse(response.body).should ==
          { 'item' =>
            { 'description' => 'NotfirstItem', 'list_id' => @openList.id, 'completed' => false }
          }
        end
     end

     describe "destroy" do
       before do
         @openList= @user.lists.create(name: "openlist", permissions: 'open' )
         @firstItem = @openList.items.create(description: "firstItem")
       end
       context "with correct user's password" do
         it "change item to complete and remove from list" do
           expect(@firstItem.completed).to eq(false)
           expect(@openList.items.count).to eq 1

           # change item completion
           params = {user_id: @user.id, password: @user.password, list_id: @openList.id, id:@firstItem.id, item: {description: @firstItem.description, completed: 'true'}}
           delete :destroy, params

           expect(@openList.items.count).to eq 0

         end
       end
     end

  end
end
