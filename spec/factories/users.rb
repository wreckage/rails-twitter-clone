require 'faker'

FactoryGirl.define do
  factory :user, class: User do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password_digest User.digest('password')
    activated true
    activated_at Time.zone.now
    transient do
        microposts_count 5
    end

    factory :user_with_microposts do
        after(:create) do |user, evaluator|
            create_list(:micropost, evaluator.microposts_count, user: user)
        end
    end

    factory :admin do
      admin true
      # after(:create) do |user|
      #     5.times { create(:micropost, user: user) }
      # end
    end
  end

  # note the block passed to content; this is so that the value gets
  # reevaluated each time an instance is created, which gives us
  # random content each time
  factory :micropost do
    user
    content { Faker::Lorem.sentence(5) }
    created_at 42.days.ago
  end
end
