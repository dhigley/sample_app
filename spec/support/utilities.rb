# Listing 5.42: Replacing the full_title test helper with a simple include.
include ApplicationHelper

# Listing 8.34: Adding a 'valid_signin' helper method.
def valid_signin(user)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
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
