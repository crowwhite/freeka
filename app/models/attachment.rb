class Attachment < ActiveRecord::Base

  # Association
  belongs_to :attacheable, polymorphic: true
  has_attached_file :attachment, styles: lambda { |attachment|
                    attachment.instance.is_image ? {:thumb => "200x200#", :medium => "300x300#"} : {} },
                    default_url: 'http://2.bp.blogspot.com/-q-kaTpPqFc0/VAb_gK-IMWI/AAAAAAAAFk0/7oNpy4MBnXo/s1600/give-charity-donations.jpg'

  # Callback
  after_validation :clean_error_duplication

  # Validation
  validates_attachment_size :attachment, less_than: 10.megabyte
  validates_attachment_content_type :attachment, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf", "text/html", "application/doc"], message: "is not valid"
  validate :image_dimensions, if: :is_image

  def url(size)
    if is_image
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
