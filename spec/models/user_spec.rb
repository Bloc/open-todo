require 'rails_helper'

describe User do 
  before do 
      @user = create(:user, password: 'password')
  end

  describe "#authenticate?" do
    it "tests for password parity" do
      expect(@user.authenticate?('password')).to eq(true)
      expect(@user.authenticate?('otherpass')).to eq(false)
    end
  end

  describe "#can?" do
    before do 
      @list = create(:list, user: @user, permissions: 'private')
    end

    it "allows owners to do whatever they want" do
      expect(@list.user).to be @user
      [:view, :edit].each { |action|
        expect(@user.can?(action, @list)).to eq(true)
      }
    end

    it "toggles abilities by permissions" do
      user2 = create(:user)
      expect(@list.user).not_to eq(user2)
      expect(@list.permissions).to eq('private')

      expect([:view, :edit].all?{ |action| 
        user2.can?(action, @list) 
      }).to eq(false)

      @list.permissions = 'visible'
      
      expect(user2.can?(:view, @list)).to eq(true)
      expect(user2.can?(:edit, @list)).to eq(false)

      @list.permissions = 'open'

      expect([:view, :edit].all?{ |action|
        user2.can?(action, @list) 
      }).to eq(true)
    end
  end

  describe "#create_api_key" do
    it "creates a key automatically for each user" do
      expect(@user.api_key).not_to be_nil
      expect(@user.api_key.access_token.length).to be 32
    end
  end

  describe "ActiveModel validations" do
    it { expect(@user).to validate_presence_of(:username).with_message( /can't be blank/ ) }
    it { expect(@user).to validate_presence_of(:password).with_message( /can't be blank/ ) }
    it { expect(@user).to validate_uniqueness_of(:username) }
  end

  describe "ActiveRecord associations" do
    it { expect(@user).to have_one(:api_key).dependent(:destroy) }
    it { expect(@user).to have_many(:lists).dependent(:destroy) }
  end
end
