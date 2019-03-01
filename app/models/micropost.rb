class Micropost < ApplicationRecord
  mount_uploader :picture, PictureUploader

  belongs_to :user

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_length}
  validate :picture_size

  scope :order_desc, ->{order created_at: :desc}

  private

  def picture_size
    settings_size = Settings.standard_memory.megabytes
    errors.add :picture, t(:picture_size) if picture.size > settings_size
  end
end
