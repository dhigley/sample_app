require 'spec_helper'

# Listing 8.1: Test for the 'new' session action and view.
describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    # Listing 8.5: The test for signin failure.
    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      # Listing 8.34: Implemented due to changes to the spec/support/utilities.rb file.
      it { should have_error_message('Invalid') }

      # Listing 8.11: Correct test for signin failure.
      describe "after visiting another page" do
        before { click_link "Home" }
        # Exercise 8: Implemented due to changes to the spec/support/utilities.rb file.
        it { should_not have_error_message('Invalid') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      # Listing 9.5: Using a helper in spec/support/utilities to sign a user inside the test.
      before { sign_in user }
      # Listing 8.34: Implemented due to changes to the spec/support/utilities.rb file.
      # before { valid_signin(user) }

      it { should have_title(user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      # Listing 9.5: Adding a test for the "Settings" link.
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      # Listing 8.28: Test for signing out a user.
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end
end
