# Listing 7.8: A factory to simulate User model objects.
FactoryGirl.define do
  factory :user do
    name "Daniel Higley"
    email "daniel@example.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end
