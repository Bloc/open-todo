require 'spec_helper'

describe List do
  before do 
    @user = create(:user)
    @list = create(:list, user: @user)
  end
  
  describe "#add" do
    it "adds the description to the item list" do
      expect{ @list.add("New Item") }
        .to change{ @list.items.where(description: 'New Item').count }
        .by 1
    end
  end

  describe "#remove" do
    before { @list.add("New Item") }

    it "finds by description and removes" do
      expect{ @list.remove("New Item") }
        .to change{ @list.items.find_by(description: "New Item").completed }
        .to true
    end

    it "returns false if nothing's there" do
      expect(@list.remove("Not There")).to be_false
    end
  end

  describe '#owner scope' do 
    it "shows only lists owned by the user" do
      other_list = create(:list)
      expect( List.all.owner(@user) ).to include(@list)
      expect( List.all.owner(@user) ).not_to include(other_list)
    end
  end

  describe '#not_private scope' do 
    it "shows only non private lists" do
      private_list = create(:list, permissions: "private")
      expect( List.not_private ).to include(@list)
      expect( List.not_private ).not_to include(private_list)
    end
  end

  describe "ActiveModel validations" do
    it { expect(@list).to validate_presence_of(:name).with_message( /can't be blank/ ) }
    it { expect(@list).to validate_presence_of(:permissions).with_message( /can't be blank/ ) }
    it { expect(@list).to validate_uniqueness_of(:name) }
    it { should validate_inclusion_of(:permissions).in_array(["open", "viewable", "private"]) }
  end

  describe "ActiveRecord associations" do
    it { expect(@list).to belong_to(:user) } 
  end
end
