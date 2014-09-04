class User < ActiveRecord::Base
  # Listing 10.8: A user has_many microposts.
  # Listing 10.13: Ensuring that a user’s microposts are destroyed along with the user.
  has_many :microposts, dependent: :destroy
  # Listing 6.26: Adding the method to get initial password test to pass.
  has_secure_password

  # Listing 6.20: Ensuring email uniqueness by downcasing email attribute before being save do the db.
  before_save { self.email = email.downcase }

  # Lisiting 8.18: A 'before_create' callback to create 'remember_token'.
  before_create :create_remember_token
  # Listing 6.10: Validating the presence of the name and email attributes.
  # Listing 6.12: Adding a length validation for the name attribute.
  validates :name, presence: true, length: { maximum: 50 }

  # Listing 6.14: Validating the email format with regular expressions.
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  # Listing 6.16: Validating the uniqueness of email addresses.
  # Listing 6.18: ignoring case.
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # Listing 6.29: Adding a minimum password length.
  validates :password, length: { minimum: 6 }

  # Listing 8.18: Create a new random 'remember_token'.
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  # Listing 8.18: Create a secure hash for the 'new_remember_token'.
  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # Listing 10.36: A preliminary implementation for the micropost status feed.
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
    # microposts
  end

  private

    # Listing 8.18: Create the secure 'remember_token' and assign it to the user.
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
