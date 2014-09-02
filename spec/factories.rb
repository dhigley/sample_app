# Listing 7.8: A factory to simulate User model objects.
# Listing 9.31: Defining a Factory Girl sequence.
FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    # Listing 9.41: Adding a factory for administrative users.
    factory :admin do
      admin true
    end
  end

  # Listing 10.9: The complete factory file, including a new factory for microposts.
  factory :micropost do
    content "Lorem ipsum"
    user
  end
end
