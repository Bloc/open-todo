require 'spec_helper'

describe ListSerializer do
  xit { should have_attribute(:id) }
  xit { should have_attribute(:name) }
  xit { should have_attribute(:user_id) }
  xit { should have_attribute(:permissions) }
  xit { should have_many_relation(:items) }
end