require 'spec_helper'

# Listing 5.34: Test for the signup page.
describe "User pages" do
  subject { page }

  describe "profile page" do
    # Listing 7.9: A test for the user show page.
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    # Excercise 5.6: Changed have_content to have_selector to be able to test
    # for the presence and content of the <h1> tag.
    it { should have_selector('h1', text: 'Sign up') }

    # Listing 5.30: Title is now being tested by spec/support/utilities.
    it { should have_title(full_title('Sign up')) }
  end

  # Listing 7.16: Basic test for signing up users.
  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      # Listing 7.31: Testing for invalid submission error page and messages.
      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        # Exercise 8: Implemented due to changes to the spec/support/utilities.rb file.
        it { should have_error_message('error') }
        # Test for errors, it should give a <li> list of each error.
        it { should have_selector('li', text: '*') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      # Listing 7.32: Test for post-save behavior in the 'create' action.
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        # Listing 8.26: Testing that newly signed-up users are also signed in.
        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        # Exercise 8: Implemented due to changes to the spec/support/utilities.rb file.
        it { should have_success_message('Welcome') }
      end
    end
  end

  # Listing 9.1: Tests for the user edit page.
  describe "edit" do
    let (:user) { FactoryGirl.create(:user) }
    # Listing 9.9: Using the new 'sign_in' method from spec/support/utilities.rb.
    before do
      sign_in user
      visit edit_user_path(user)
    end
    # before { visit edit_user_path(user) }

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    # Listing 9.9: Test for the user 'update' action.
    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      # it { should have_success_message('Success') }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end
