require 'spec_helper'

# Listing 5.34: Test for the signup page.
describe "User pages" do
  subject { page }

  # Listing 9.22: Tests for the user index page.
  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    # Listing 9.32: Tests for pagination.
    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    # Listing 9.42: Tests for delete links.
    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    # Listing 7.9: A test for the user show page.
    let(:user) { FactoryGirl.create(:user) }
    # Listing 10.16: A test for showing microposts on the user show page.
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    # Listing 10.16: A test for showing microposts on the user show page.
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
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
        fill_in "Confirm Password", with: "foobar"
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

    # Listing 9.48: Testing that the admin attribute is forbidden.
    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end
