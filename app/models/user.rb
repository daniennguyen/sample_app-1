class User < ApplicationRecord
  before_save{self.email = email.downcase}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i  
  validates :name, presence: true, length: 
    {minimum: Settings.min_length_name, maximum: Settings.max_length_name}
  validates :email, presence: true, length: 
    {minimum: Settings.min_length_email, maximum: Settings.max_length_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min_length_password}
  has_secure_password

  def self.digest string
    if cost = ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
    BCrypt::Password.create string, cost: cost
  end
end
