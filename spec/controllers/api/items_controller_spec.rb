require 'spec_helper'

describe Api::ItemsController do

  before do
    User.destroy_all
    List.destroy_all
    Item.destroy-all
  end

  describe "create" do
      before do
        @user = create(:user)
      end

    context "with correct user's password" do
      xit "takes a item name, creates it if it doesn't exist, and returns false if it does" do
      end
    end


    context "without correct user's password" do
      xit "it errors" do
      end
    end
  end

  describe "index" do

    before do
      @user = create(:user)
    end

    context "with correct user's password" do
      xit "returns all items associated with a list" do
      end
    end

    context "without correct user's password" do
      xit "returns all items if list is visible or open" do
      end
    end



  end





end
