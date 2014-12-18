require 'spec_helper'

describe Api::ListsController do

  before do
    User.destroy_all
    List.destroy_all
    @user = create(:user)
  end


  describe "destroy" do

    context "with correct user's password" do
        it "remove a list" do
        params = { user_id: @user.id, password: @user.password,list:  { name: 'test_list', permissions: 'open' } }
        post :create, params
        expect(List.count).to eq 1
        List.last.delete
        expect(List.count).to eq 0
      end
    end
  end

  describe "update" do
      before do
        @openList= @user.lists.create(name: "openlist", permissions: 'open' )
        @viewableList= @user.lists.create(name: "viewablelist", permissions: 'viewable' )
        @privateList= @user.lists.create(name: "privatelist", permissions: 'private' )
      end

      context "with correct user's password" do
        it "change list permissions" do
          params = {user_id: @user.id, password: @user.password, id: @openList.id, list: { name: @openList.name, permissions: 'private'}}
          put :update, params
          JSON.parse(response.body).should ==
          { 'list' =>

              { 'name' => 'openlist', 'user_id' => @user.id, 'permissions' => 'private' }

          }
        end

        it "can not edit a list if it viewable" do
          params = {user_id: @user.id, password: @user.password, id: @viewableList.id, list: { name: 'Shouldnotwork', permissions: @viewableList.permissions}}
         put :update, params

          expect(response.status).to eq(500)
        end

        it "gives an error when attempting to set an unsupported permission" do
          params = {user_id: @user.id, password: @user.password, id: @privateList.id, list: { permissions: 'wrongpermission'}}
          response = put :update, params
          puts response.body.inspect
          expect(response.status).to eq(500)
        end


      end

      context "with incorrect user's password" do
        it "give error when editing a List" do
          params = {user_id: @user.id, password: 'wrongpassword', id: @openList.id, list: { permissions: 'private'}}
          put :update, params
          expect(response.status).to eq(401)
        end
      end
  end


  describe "create" do


    context "with correct user's password" do
      it "takes a list name, creates it if it doesn't exist, and returns false if it does" do
        params = { user_id: @user.id, password:@user.password, list:  { name: 'test_list', permissions: 'open' } }
        post :create, params

        expect(List.last.name).to eq('test_list')
        expect(List.count).to eq(1)
        JSON.parse(response.body).should ==
        { 'list' =>
            { 'name' => 'test_list', 'user_id' => @user.id, 'permissions' => 'open' }
        }
        post :create, params
        expect(response.status).to eq(500)


      end
    end

    context "without correct user's password" do
      it "it errors" do
        params = { user_id: @user.id, password:'wrongpassword',list:  { name: 'test_list', permissions: 'open' } }
        post :create, params
        expect(response.status).to eq(401)
      end
    end

  end

  describe "index" do

    before do
      openList= @user.lists.create(name: "openlist", permissions: 'open' )
      visibleList= @user.lists.create(name: "visiblelist", permissions: 'visible' )
      privateList= @user.lists.create(name: "privatelist", permissions: 'private' )
    end

      context "with correct user's password" do
        it "returns all lists associated with the user" do
          params = {user_id: @user.id, password: @user.password}
          get :index, params

          JSON.parse(response.body).should ==
          { 'lists' =>
            [
              { 'name' => 'openlist', 'user_id' => @user.id, 'permissions' => 'open' },
              { 'name' => 'visiblelist', 'user_id' => @user.id, 'permissions' => 'visible'},
              { 'name' => 'privatelist', 'user_id' => @user.id, 'permissions' => 'private' }
            ]
          }
        end
      end

      context "without correct user's password" do
        it "returns all visible and open lists" do
        params = {user_id: @user.id, password: 'wrongpassword'}
        get :index, params

        JSON.parse(response.body).should ==
        { 'lists' =>
          [
            { 'name' => 'openlist', 'user_id' => @user.id, 'permissions' => 'open' },
            { 'name' => 'visiblelist', 'user_id' => @user.id, 'permissions' => 'visible'},
          ]
        }
        end
      end

    end



  end
