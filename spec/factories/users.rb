require 'faker'

FactoryGirl.define do
  factory :user do |f|
    name "John"
    email "johndoe@example.com"
    password_digest User.digest('password')
    admin true
    activated true
    activated_at Time.zone.now
  end

  factory :user2, class: User do |f|
    name "abigail"
    email "abby2@example.com"
    password_digest User.digest('password')
    activated true
    activated_at Time.zone.now
  end
end

# FactoryGirl.define do
#   factory :user do |f|
#     f.name "John"
#     f.email "johndoe@example.com"
#     f.password "foobar"
#     f.password_confirmation "foobar"
#   end
# end

# FactoryGirl.define do
#   factory :contact do |f|
#     f.firstname { Faker::Name.first_name }
#     f.lastname { Faker::Name.last_name }
#     f.password { Faker::Internet.password }
#   end
# end
