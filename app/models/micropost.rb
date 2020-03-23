class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc)}

  # чтобы указать CarrierWave на связь изображения с моделью, нужно воспользоваться методом mount_uploader,
  # в качестве аргумента он принимает символ, представляющий атрибут, и имя класса созданного загрузчика:
  mount_uploader :picture, PictureUploader


  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140}
  validate  :picture_size

  private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "sorry, but picture should be less than 5MB")
    end
  end
end
