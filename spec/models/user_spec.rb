# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string
#

require 'spec_helper'

describe User do
  describe "authenticate?" do

    let(:user) { FactoryGirl.build(:user, password: 'password') }

    it "tests for password parity" do
      expect(user.authenticate?('password')).to be_truthy
      expect(user.authenticate?('otherpass')).to be_falsey
    end
  end

  describe "can?" do

    before do
      @user = FactoryGirl.create(:user)
      @list = FactoryGirl.create(:list, user: @user)
    end

    it "allows owners to do whatever they want" do
      expect(@list.user).to eq(@user)
      [:view, :edit].each { |action|
        expect(@user.can?(action, @list)).to be_truthy
      }
    end

    it "toggles abilities by permissions" do
      user2 = FactoryGirl.create(:user)
      expect(@list.user).not_to eq(user2)
      expect(@list.permissions).to eq('private')

      expect([:view, :edit].all?{ |action|
        user2.can?(action, @list)
      }).to be_falsey

      @list.permissions = 'visible'

      expect(user2.can?(:view, @list)).to be_truthy
      expect(user2.can?(:edit, @list)).to be_falsey

      @list.permissions = 'open'

      expect([:view, :edit].all?{ |action|
        user2.can?(action, @list)
      }).to be_truthy
    end
  end

end
