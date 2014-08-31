# Listing 5.42: Replacing the full_title test helper with a simple include.
include ApplicationHelper

# Listing 9.6: A test helper to sign in users.
def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

def sign_out
  click_link "Sign out"
end

# Listing 8.34: Adding a custom RSpec matcher.
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

# Exercise 8: Adding a custom RSpec matcher.
RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: message)
  end
end
