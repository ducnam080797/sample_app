class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, foreign_key: "follower_id",
    class_name: Relationship.name,
    dependent: :destroy
  has_many :passive_relationships, class_name:  Relationship.name,
    foreign_key: "followed_id",
    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_reader :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  before_save :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true,
    length: {maximum: Settings.user_validate.maximum_name}
  validates :email, presence: true,
    length: {maximum: Settings.user_validate.maximum_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :password, presence: true, allow_nil: true,
    length: {maximum: Settings.user_validate.maximum_password}

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
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

  def feed
    microposts
  end

  def following? other_user
    following.include? other_user
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def forget
    update remember_digest: nil
  end

  def current_user? user
    self == user
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def create_reset_digest
    @reset_token = User.new_token
    update reset_digest: User.digest(reset_token)
    update reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    @activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
