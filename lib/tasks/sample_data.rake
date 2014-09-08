# Listing 11.17: Defining separate methods to make users, microposts, and sample relationship data.
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    # Listing 11.17: Adding following/follower relationships to the sample data.
    make_users
    make_microposts
    make_relationships
  end
end

# Listing 9.29: A Rake task for populating the database with sample users.
# Listing 9.40: The sample data populator code with an admin user.
def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar",
                       admin: true)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

# Listing 10.20: Adding microposts to the sample data.
def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

# Listing 11.17: Adding following/follower relationships to the sample data.
def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end
