# spec/factories/users.rb

FactoryBot.define do
  factory :user, class: 'UserRecord' do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    role { 'member' }

    trait :admin do
      role { 'admin' }
    end

    trait :manager do
      role { 'manager' }
    end

    trait :member do
      role { 'member' }
    end
  end
end