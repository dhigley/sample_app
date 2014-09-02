class Micropost < ActiveRecord::Base
  # Listing 10.7: A micropost belongs_to a user.
  belongs_to :user
  # Listing 10.11: Ordering the microposts with default_scope.
  default_scope -> { order('created_at DESC') }
  # Listing 10.15: A validation for the micropost’s content and length.
  validates :content, presence: true, length: { maximum: 140 }
  # Listing 10.4: A validation for the micropost’s user_id.
  validates :user_id, presence: true
end
