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
    end
  end
end
