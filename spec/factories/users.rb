require 'faker'

FactoryGirl.define do
  factory :user2, class: User do
    name "abigail"
    email "abby2@example.com"
    password_digest User.digest('password')
    activated true
    activated_at Time.zone.now
    transient do
        microposts_count 5
    end
    after(:create) do |user, evaluator|
        create_list(:micropost, evaluator.microposts_count, user: user)
    end

    factory :user do
      name "john"
      email "johndoe@example.com"
      admin true
    end

    factory :user3 do
      name "lana"
      email "lana2@example.com"
    end
  end

  factory :micropost do
    user
    content Faker::Lorem.sentence(5)
    created_at 42.days.ago
  end

end

FactoryGirl.define do
  factory :relationship1, class: Relationship do
      user
      follower :user
      followed :user2
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
