class User < ActiveRecord::Base
  # Listing 6.20: Ensuring email uniqueness by downcasing email attribute before being save do the db.
  before_save { self.email = email.downcase }
  # Listing 6.10: Validating the presence of the name and email attributes.
  # Listing 6.12: Adding a length validation for the name attribute.
  validates :name, presence: true, length: { maximum: 50 }

  # Listing 6.14: Validating the email format with regular expressions.
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # Listing 6.16: Validating the uniqueness of email addresses.
  # Listing 6.18: ignoring case.
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # Listing 6.26: Adding the method to get initial password test to pass.
  has_secure_password

  # Listing 6.29: Adding a minimum password length.
  validates :password, length: { minimum: 6 }
end
