# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :api_key do
    user_id 1
    access_token "secrettoken"
  end
end
