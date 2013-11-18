class Tweet < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  def self.from_users_followed_by(user)
    where("user_id IN
              (SELECT
                followed_id
              FROM
                relationships
              WHERE
                follower_id = :user_id)
            OR user_id = :user_id",
          user_id: user.id)
  end
end
