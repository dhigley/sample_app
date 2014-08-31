require 'spec_helper'

# Listing 8.1: Test for the 'new' session action and view.
describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
    # Exercise 9: Profile and Settings links should not appear when a user is not signed in.
    it { should_not have_link('Users', href: users_path) }
    it { should_not have_link('Profile') }
    it { should_not have_link('Settings') }
    it { should_not have_link('Sign out', href: signout_path) }

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

      it { should have_title(user.name) }
      # Listing 9.26: A test for the “Users” link URL.
      it { should have_link('Users', href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      # Listing 9.5: Adding a test for the "Settings" link.
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      # Listing 8.28: Test for signing out a user.
      describe "followed by signout" do
        before { sign_out }
        it { should have_link('Sign in') }
        # Exercise 9: Profile and Settings links should not appear when a user is not signed in.
        it { should_not have_link('Users', href: users_path) }
        it { should_not have_link('Profile') }
        it { should_not have_link('Settings') }
        it { should_not have_link('Sign out', href: signout_path) }
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
          sign_in user
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end

          #### Exercise 9: Make sure friendly forwarding only forwards to the given URL the first time.
          describe "when signing in again" do
            before do
              sign_out
              sign_in user
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(user.name)
            end
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

        # Listing 9.20: Testing that the 'index' action is protected.
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
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

    # Listing 9.45: A test for protecting the destroy action.
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    # Exercise 9: Protect the 'new' and 'create' actions from signed in users.
    describe "as a signed-in user" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET reqeust to the Users#new action" do
        before { get new_user_path }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a POST request to the Users#create action" do
        before { post users_path }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    # Exercise 9: Prevent admin users from destroying themselves.
    describe "as an admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin, no_capybara: true
        visit users_path
      end

      describe "submitting a DELETE reqeust on themselves" do
        specify { expect { delete user_path(admin) }.not_to change(User, :count) }
      end
    end
  end
end
