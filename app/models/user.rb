class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  attr_reader :remember_token

  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: "followed_id", dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: "follower_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :following, through: :active_relationships, source: :followed

  validates :name, presence: true, length:
    {minimum: Settings.min_length_name,
     maximum: Settings.max_length_name}
  validates :email, presence: true, length:
    {minimum: Settings.min_length_email,
     maximum: Settings.max_length_email},
      format: {with: VALID_EMAIL_REGEX},
      uniqueness: {case_sensitive: false}
  validates :password, presence: true, length:
    {minimum: Settings.min_length_password},
      allow_nil: true

  before_save{self.email = email.downcase}

  class << self
    def digest string
      if cost = ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    @remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update remember_digest: nil
  end

  def feed
    microposts.where user_id: following_ids << id
  end

  def current_user? user
    self == user
  end

  def password_reset_expired?
    reset_sent_at < Settings.expired_times.hours.ago
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end
end
