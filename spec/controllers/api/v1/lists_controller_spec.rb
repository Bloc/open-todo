require 'spec_helper'

describe Api::V1::ListsController do 

  describe "#create" do
    context "with correct user's password" do
      xit "takes a list name, creates it if it doesn't exist, and returns false if it does"
    end

    context "without correct user's password" do
      xit "it errors"
    end
  end

  describe "#index" do

    before do
      user = create(:user)
      openlist = create(:list, name: 'openlist', permissions: 'open')
      viewablelist = create(:list, name: 'viewablelist', permissions: 'viewable')
      privatelist = create(:list, name: 'privatelist', permissions: 'private')
    end

    context "with correct user's password" do
      xit "returns all lists associated with the user"
      params = {'user' => '1'}
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
end