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

  # Listing 9.11: Testing that the 'edit' and 'update' actions are protected.
  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      # Listing 9.16: A test for friendly forwarding.
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end

      describe "in the users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    # Listing 9.13: Testing that the 'edit' and 'update' actions require the right user.
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }

      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end
