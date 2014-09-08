require 'spec_helper'

describe User do

  # Listing 6.5: Testing for :name and :email attributes.
  # Listing 6.24: Testing for the password and password_confirmation attributes.
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  # Listing 6.22: Making sure that a User object has a password_digest column.
  it { should respond_to(:password_digest) }
  # Listing 6.24: Testing for the password and password_confirmation attributes.
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  # Listing 8.15: A first test for the remmber token
  it { should respond_to(:remember_token) }
  # Listing 6.28: Test for authenticate method.
  it { should respond_to(:authenticate) }
  # Listing 9.38: Tests for an admin attribute.
  it { should respond_to(:admin) }
  # Listing 10.6: A test for the user’s microposts attribute.
  it { should respond_to(:microposts) }
  # Listing 10.35: Tests for the (proto-)status feed.
  it { should respond_to(:feed) }
  # Listing 11.3: Testing for the user.relationships attribute.
  it { should respond_to(:relationships) }
  # Listing 11.9: A test for the user.followed_users attribute.
  it { should respond_to(:followed_users) }
  # Listing 11.11: Tests for some “following” utility methods.
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  # Listing 11.13: A test for unfollowing a user.
  it { should respond_to(:unfollow!) }
  # Listing 11.15: Testing for reverse relationships.
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }

  it { should be_valid }
  it { should_not be_admin }

  # Listing 9.38: Tests for an admin attribute.
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  # Listing 6.8: A failing test for the validation of the name attribute.
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  # Listing 6.9: a test for presence of the email attribute.
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  # Listing 6.11: A test for name length validation.
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  # Listing 6.13: Test for email format validation.
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  # Listing 6.15: A test for the rejection of duplicate email addresses.
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      # Listing 6.17: Rejecting duplicate email addresses, insensitive to case.
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  # Listing 6.30: A test for the email downcasing taking place in app/models/user.rb.
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  # Listing 6.25: Test for password and password confirmation.
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  # Listing 6.28: Test for authenticate method.
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  # Listing 6.28: Test for password length.
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  # Listing 8.17: A test for a valid (nonblank) remember token.
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  # Listing 10.10: Testing the order of a user’s microposts.
  describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    # Listing 10.12: Testing that microposts are destroyed when users are.
    it "should destroy associated micropost" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    # Listing 10.35: Tests for the (proto-)status feed.
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      # Listing 11.41: The final tests for the status feed.
      let!(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  # Listing 11.11: Tests for some “following” utility methods.
  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }
      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end

    # Listing 11.15: Testing for reverse relationships.
    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end
  end
end
