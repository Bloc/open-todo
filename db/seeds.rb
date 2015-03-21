require 'faker'

# Create Users
100.times do
  password = Faker::Lorem.characters(10)
  user = User.create!(
      username: Faker::Name.name,
      password: password,
      password_confirmation: password
    )
  user.update_attributes!(created_at: rand(10.minutes .. 1.year).ago)
end
users = User.all

# Create Lists
168.times do
  list = List.create!(
      user: users.sample,
      name: Faker::Lorem.sentence,
      permissions: 'private'
    )
  list.update_attributes!(created_at: rand(10.minutes .. 1.year).ago)
end

166.times do
  list = List.create!(
      user: users.sample,
      name: Faker::Lorem.sentence,
      permissions: 'viewable'
    )
  list.update_attributes!(created_at: rand(10.minutes .. 1.year).ago)
end

166.times do
  list = List.create!(
      user: users.sample,
      name: Faker::Lorem.sentence,
      permissions: 'open'
    )
  list.update_attributes!(created_at: rand(10.minutes .. 1.year).ago)
end

lists = List.all

# Create Items
2500.times do
  item = Item.create!(
      list: lists.sample,
      description: Faker::Lorem.sentence,
      completed: false
    )
  item.update_attributes!(created_at: rand(10.minutes .. 1.year).ago)
end

puts "Seed finished"
puts "#{User.count} users created"
puts "#{List.count} lists created"
puts "#{Item.count} items created"
