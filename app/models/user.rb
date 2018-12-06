class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: Settings.user_validate.maximum_name}
  VALID_EMAIL_REGEX= /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.user_validate.maximum_email}, 
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: {maximum: Settings.user_validate.maximum_password}
end
