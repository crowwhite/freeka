class Attachment < ActiveRecord::Base

  # Association
  belongs_to :requirement
  has_attached_file :description, default_url: 'http://beyondplm.com/wp-content/uploads/2011/07/Picture-351.png'

  # Callback
  after_validation :clean_error_duplication

  # Validation
  validates_attachment_size :description, less_than: 10.megabyte
  validates_attachment_content_type :description, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf", "text/html", "application/doc"], message: "is not valid"
  validate :image_dimensions, if: :is_image

  def url
    description.url
  end

  private
    def is_image
      ["image/jpg", "image/jpeg", "image/png", "image/gif"].include?(description.content_type)
    end

    def image_dimensions
      dimensions = Paperclip::Geometry.from_file(self.description.queued_for_write[:original].path)

      errors.add(:description, "Width must be between 300px to 700px") unless dimensions.width <= 700 && dimensions.width >= 300
      errors.add(:description, "Height must be between 300px to 700px") unless dimensions.height <= 700 && dimensions.height >= 300
    end

    def clean_error_duplication
      errors.delete(:'description_file_size')
    end
end
