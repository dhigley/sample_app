class Micropost < ActiveRecord::Base
  # Listing 10.7: A micropost belongs_to a user.
  belongs_to :user
  # Listing 10.11: Ordering the microposts with default_scope.
  default_scope -> { order('created_at DESC') }
  # Listing 10.15: A validation for the micropost’s content and length.
  validates :content, presence: true, length: { maximum: 140 }
  # Listing 10.4: A validation for the micropost’s user_id.
  validates :user_id, presence: true

  # Listing 11.43: A first cut at the from_users_followed_by method.
  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    # Listing 11.45: The final implementation of from_users_followed_by.
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end
