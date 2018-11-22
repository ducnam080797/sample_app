class User < ApplicationRecord
  before_save :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length:
  {maximum: Settings.user_validate.maximum_name}
  validates :email, presence: true,
    length: {maximum: Settings.user_validate.maximum_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  has_secure_password
  validates :password, presence: true,
    length: {maximum: Settings.user_validate.maximum_password}

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  def downcase_email
    email.downcase!
  end
end
