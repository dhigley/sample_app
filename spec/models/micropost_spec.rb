require 'spec_helper'

describe Micropost do
  # Listing 10.2: The initial Micropost spec.
  let(:user) { FactoryGirl.create(:user) }
  # Listing 10.5: Tests for the micropost’s user association.
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  # Listing 10.3: Tests for the validity of a new micropost.
  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  # Listing 10.14: Tests for the Micropost model validations.
  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end
