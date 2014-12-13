class Attachment < ActiveRecord::Base

  # Association
  belongs_to :attacheable, polymorphic: true
  has_attached_file :attachment, styles: lambda { |attachment|
                    attachment.instance.is_image ? {:thumb => "300x300>", :medium => "500x500>"} : {} },
                    default_url: 'http://beyondplm.com/wp-content/uploads/2011/07/Picture-351.png'

  # Callback
  after_validation :clean_error_duplication

  # Validation
  validates_attachment_size :attachment, less_than: 10.megabyte
  validates_attachment_content_type :attachment, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf", "text/html", "application/doc"], message: "is not valid"
  # validate :image_dimensions, if: :is_image

  def url(size)
    attachment.url(size)
  end

    def is_image
      ["image/jpg", "image/jpeg", "image/png", "image/gif"].include?(attachment.content_type)
    end
  private

    def image_dimensions
      dimensions = Paperclip::Geometry.from_file(self.attachment.queued_for_write[:original].path)

      errors.add(:attachment, "Width must be between 300px to 700px") unless dimensions.width <= 700 && dimensions.width >= 300
      errors.add(:attachment, "Height must be between 300px to 700px") unless dimensions.height <= 700 && dimensions.height >= 300
    end

    def clean_error_duplication
      errors.delete(:'attachment_file_size')
    end
end
