require 'spec_helper'

describe Api::ListsController do 
  describe "create" do
    context "with correct user's password" do
      xit "takes a list name, creates it if it doesn't exist, and returns false if it does"
    end

    context "without correct user's password" do
      xit "it errors"
    end
  end

  describe "index" do
    context "with correct user's password" do
      xit "returns all lists associated with the user"
    end

    context "without correct user's password" do
      xit "returns all visible and open lists"
    end
  end
end