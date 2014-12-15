require 'spec_helper'

describe Api::ListsController do

  before do
    User.destroy_all
    List.destroy_all
  end

  describe "create" do
    before do
      @user = create(:user)
    end

    context "with correct user's password" do
      it "takes a list name, creates it if it doesn't exist, and returns false if it does" do
        params = { user_id: @user.id, password:@user.password, list:  { name: 'test_list', permissions: 'open' } }
        response = post :create, params
        puts response.body.inspect
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
      @user = create(:user)
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
