require 'rails_helper'

describe ApiKey do
  before do 
    @api_key = create(:api_key)
  end
  
  describe ".generate_access_token" do
    it "make an access token " do
      expect(@api_key.access_token.length).to be 32
    end
  end

  describe "ActiveRecord associations" do
    it { expect(@api_key).to belong_to(:user) } 
  end
end
