require 'spec_helper'

describe User do 
  describe "authenticate?" do

    let(:user) { FactoryGirl.build(:user, password: 'password') }
    
    it "tests for password parity" do
      user.authenticate?('password').should be_true
      user.authenticate?('otherpass').should be_false
    end
  end

  describe "can?" do

    before do 
      @user = FactoryGirl.create(:user)
      @list = FactoryGirl.create(:list, user: @user)
    end

    it "allows owners to do whatever they want" do
      @list.user.should be @user
      [:view, :edit].each { |action|
        @user.can?(action, @list).should be_true
      }
    end

    it "toggles abilities by permissions" do
      user2 = FactoryGirl.create(:user)
      @list.user.should_not be user2
      @list.permissions.should == 'private'

      [:view, :edit].all?{ |action| 
        user2.can?(action, @list) 
      }.should be_false

      @list.permissions = 'visible'
      
      user2.can?(:view, @list).should be_true
      user2.can?(:edit, @list).should be_false

      @list.permissions = 'open'

      [:view, :edit].all?{ |action|
        user2.can?(action, @list) 
      }.should be_true
    end
  end

end