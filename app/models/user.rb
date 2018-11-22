class User < ApplicationRecord
  validates :name, presence: true, lenght: { maximum: Settings.user_validate.maximum_name }
  VALID_EMAIL_REGEX= /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, lenght: { maximum: Settings.user_validate.minimum_email }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: Settings.user_validate.minimum_password }
end
