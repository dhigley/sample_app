require 'spec_helper'

describe "StaticPages" do

  # Eliminate duplication by telling RSpec that 'page' is the subject of the test.
  subject { page }

  # Listing 5.39: Using RSpec shared example to eliminate test duplication.
  shared_examples_for "all static pages" do
    # Excercise 5.6: Changed have_content to have_selector to be able to test
    # for the presence and content of the <h1> tag.
    it { should have_selector('h1', text: heading) }
    # Listing 5.30: Title is now being tested by spec/support/utilities.
    it { should have_title(full_title(page_title)) }
  end

  # Listing 3.9: Code to test the content of the Home page.
  # Listing 5.23: Test for named routes by changing visit 'static_pages/page' to page_path.
  describe "Home page" do
    # Cleaning up the test with one visit to the page.
    before { visit root_path }
    # Listing 5.39: Using RSpec shared example to eliminate test duplication.
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    # Using the page variable 'it' method to collapse the code and description in to one line.
    it_should_behave_like "all static pages"

    # Listing 3.19: title test
    # Listing 4.4: Updated test for the Home page's title.
    it { should_not have_title( '| Home') }

    # The home page should have a link to sign in.
    it { should have_link('Sign in', href: signin_path) }

    # Listing 10.37: A test for rendering the feed on the Home page.
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      # Exercise 10: Add tests for the sidebar micropost counts (including proper pluralization).
      describe "sidebar display count" do

        it "should pluralize for multiple post" do
          expect(page).to have_selector('span', text: "#{Micropost.count} microposts")
        end

        it "should be singular for just one post" do
          click_link("delete", match: :first)
          expect(page).to have_selector('span', text: "#{Micropost.count} micropost")
        end
      end
    end
  end

  # Listing 3.12: Adding code to test the contents of the Help page.
  describe "Help page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    # Using the page variable 'it' method to collapse the code and description in to one line.
    # Listing 5.39: Using RSpec shared example to eliminate test duplication.
    it_should_behave_like "all static pages"
  end

  # Listing 3.14: Adding code to test the contents of the About page.
  describe "About page" do
    before { visit about_path }
    let(:heading) { 'About' }
    let(:page_title) { 'About' }

    it_should_behave_like "all static pages"
  end

  # Excercises 3: Make a contact page
  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    # Listing 5.39: Using RSpec shared example to eliminate test duplication.
    it_should_behave_like "all static pages"
  end

  # Listing 5.40: A test for the links on the layout.
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About' ))
    click_link "Help"
    expect(page).to have_title(full_title('Help' ))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact' ))
    click_link "Home"
    expect(page).to have_title(full_title(''))
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end
end
