class Tweet < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  def self.from_users_followed_by(user)
    where("user_id IN(?) OR user_id = ?", user.followed_user_ids, user)
  end
end
