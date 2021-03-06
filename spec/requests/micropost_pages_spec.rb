require 'spec_helper'

# Listing 10.26: Tests for creating microposts.
describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  # Listing 10.45: Tests for the Microposts controller destroy action.
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  # Exercise 10: Add tests for micropost pagination.
  describe "micropost pagination" do
    before do
      31.times { FactoryGirl.create(:micropost, user: user) }
      visit root_path
    end
    after { user.microposts.destroy_all }

    it "should paginate the micropost" do
      Micropost.paginate(page: 1).each do |post|
        expect(page).to have_selector('li', text: post.content)
      end
    end

    it { should have_selector("div.pagination") }
  end
end
