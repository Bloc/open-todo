# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    list_id 1
    description "MyString"
    completed false
  end
end
