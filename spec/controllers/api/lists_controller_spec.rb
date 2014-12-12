require 'spec_helper'

describe Api::ListsController do

  before do
    User.destroy_all
    List.destroy_all
  end

  describe "create" do
    context "with correct user's password" do
      xit "takes a list name, creates it if it doesn't exist, and returns false if it does"
    end

    context "without correct user's password" do
      xit "it errors"
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
