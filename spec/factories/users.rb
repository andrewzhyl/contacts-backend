FactoryGirl.define do

  factory :user, class: User do

    password "111111"

    trait :login do
      email "login@gmail.com"
      username "login"
    end

    trait :regular  do
      email "andrew.zhyl@gmail.com"
      username "andrewzhyl"
    end

    # This will use the User class (Admin would have been guessed)
    trait :admin do

    end

    factory :user_login, traits: [:login]
    factory :user_regular, traits: [:regular]
    # factory :user_admin, traits: [:has_name, :admin]
    # factory :user_manager, traits: [:has_name, :manager]

  end
end
