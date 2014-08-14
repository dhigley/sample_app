require 'spec_helper'

describe "StaticPages" do

  # Exercise 3: Eliminate some repetition.
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  # Eliminate duplication by telling RSpec that 'page' is the subject of the test.
  subject { page }

  # Listing 3.9: Code to test the content of the Home page.
  # Listing 5.23: Test for named routes by changing visit 'static_pages/page' to page_path.
  describe "Home page" do
    # Cleaning up the test with one visit to the page.
    before { visit root_path }

    # Using the page variable 'it' method to collapse the code and description in to one line.
    it { should have_content('Sample App') }

    # Listing 4.4: Updated test for the Home page's title.
    it { should have_title(base_title) }

    # Listing 3.19: title test
    # Listing 4.4: Updated test for the Home page's title.
    it { should_not have_title( '| Home') }
  end

  # Listing 3.12: Adding code to test the contents of the Help page.
  describe "Help page" do
    before { visit help_path }

    # Using the page variable 'it' method to collapse the code and description in to one line.
    it { should have_content('Help') }

    # Listing 3.19: title test
    it { should have_title("#{base_title} | Help") }
  end

  # Listing 3.14: Adding code to test the contents of the About page.
  describe "About page" do
    before { visit about_path }

    it { should have_content('About Us') }

    # Listing 3.19: title test
    it { should have_title("#{base_title} | About") }
  end

  # Excercises 3: Make a contact page
  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title("#{base_title} | Contact") }
  end
end
