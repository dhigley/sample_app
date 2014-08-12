require 'spec_helper'

describe "StaticPages" do

  # Excercise 3: Eliminate some repetition.
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  # Listing 3.9: Code to test the contnet of the Home page.
  describe "Home page" do

    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end

    # Listing 4.4: Updated test for the Home page's title.
    it "should have the base title" do
      visit '/static_pages/home'
      expect(page).to have_title(base_title)
    end

    # Lising 3.19: title test
    # Listing 4.4: Updated test for the Home page's title.
    it "should not have a custom page title" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| Home')
    end
  end

  # Listing 3.12: Adding code to test the contents of the Help page.
  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    # Lising 3.19: title test
    it "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("#{base_title} | Help")
    end
  end

  # Listing 3.14: Adding code to test the contents of the About page.
  describe "About page" do

    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    # Lising 3.19: title test
    it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("#{base_title} | About")
    end
  end

  # Excercises 3: Make a contact page
  describe "Contact page" do

    it "should have the content 'Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_content('Contact')
    end

    it "should have the right title" do
      visit '/static_pages/contact'
      expect(page).to have_title("#{base_title} | Contact")
    end
  end
end
