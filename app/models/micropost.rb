class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_desc, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.maximum_micropost}
  validate :picture_size

  private

  def picture_size
    return if picture.size <= Settings.size_picture_page.megabytes
    errors.add :picture, I18n.t("should_be_size")
  end
end
