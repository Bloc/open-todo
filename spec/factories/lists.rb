# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :list do
    name "Shopping List"
    user_id '1'
    permissions "private"
  end
end
