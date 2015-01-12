#FIXME_AB: Since it is a polymorphic table we should have composite  index on type and id field
# Fixed
class Attachment < ActiveRecord::Base
  SIZES = [:thumb, :medium]

  SIZES = [:medium, :thumb, :original]

  # Association
  belongs_to :attacheable, polymorphic: true
  has_attached_file :attachment, styles: lambda { |attachment|
                    attachment.instance.is_image ? { :thumb => "200x200#", :medium => "300x300#" } : {} },
                    default_url: '/give-charity-donations.jpg'

  # Callback
  after_validation :clean_error_duplication

  # Validation
  validates :caption, length: { maximum: 15 }
  validates_attachment_size :attachment, less_than: 10.megabyte
  #FIXME_AB: We are not displaying valid attachment types in frontend
  # Fixed
  validates_attachment_content_type :attachment, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf", "text/html", "application/doc"], message: "is not valid"
  validate :image_dimensions, if: :is_image

  def url(size = :original)
    if is_image && SIZES.include?(size)
      attachment.url(size)
    else
      attachment.url(:original)
    end
  end

  def is_image
    ["image/jpg", "image/jpeg", "image/png", "image/gif"].include?(attachment.content_type)
  end

  private

    def image_dimensions
      if image = self.attachment.queued_for_write[:original]
        dimensions = Paperclip::Geometry.from_file(image.path)
        errors.add(:attachment, "Width must be between 300px to 700px") unless dimensions.width <= 700 && dimensions.width >= 300
        errors.add(:attachment, "Height must be between 300px to 700px") unless dimensions.height <= 700 && dimensions.height >= 300
      end
    end

    def clean_error_duplication
      errors.delete(:'attachment_file_size')
    end
end
