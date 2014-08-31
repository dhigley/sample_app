# Listing 9.29: A Rake task for populating the database with sample users.
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    # Listing 9.40: The sample data populator code with an admin user.
    admin = User.create!(name: "Example User",
                         email: "example@railstutorial.org",
                         password: "foobar",
                         password_confirmation: "foobar",
                         admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end
