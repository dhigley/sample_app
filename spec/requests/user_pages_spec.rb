require 'spec_helper'

# Listing 5.34: Test for the signup page.
describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    # Excercise 5.6: Changed have_content to have_selector to be able to test
    # for the presence and content of the <h1> tag.
    it { should have_selector('h1', text: 'Sign up') }

    # Listing 5.30: Title is now being tested by spec/support/utilities.
    it { should have_title(full_title('Sign up')) }
  end
end
