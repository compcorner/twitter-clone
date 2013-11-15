class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  has_secure_password
  before_create :create_session_token

  def timeline
    Tweet.where("user_id = ?", id)
  end

  before_save do
    self.email = email.downcase
  end

  def User.new_session_token
    token = SecureRandom.urlsafe_base64
    return token
  end

  def User.encrypt(token)
    encrypted = Digest::SHA1.hexdigest(token.to_s)
    return encrypted
  end

  private

    def create_session_token
      self.session_token = User.encrypt(User.new_session_token)
    end
end
