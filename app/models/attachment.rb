#FIXME_AB: Since it is a polymorphic table we should have composite  index on type and id field
class Attachment < ActiveRecord::Base
  #FIXME_AB: Why do we need requirement_id
  # tobefixed: We don't need it now. will remove it.

  # Association
  belongs_to :attacheable, polymorphic: true
  has_attached_file :attachment, styles: lambda { |attachment|
                    #FIXME_AB: Do you understand what does # or > mean when you specify thumbnail sizes
                    # Fixed: the #crops the picture wrt to centre where as > crops taking the start point as reference
                    attachment.instance.is_image ? {:thumb => "200x200#", :medium => "300x300#"} : {} },
                    #FIXME_AB: Why we have have specified this URL? do we have any better way?
                    default_url: 'http://2.bp.blogspot.com/-q-kaTpPqFc0/VAb_gK-IMWI/AAAAAAAAFk0/7oNpy4MBnXo/s1600/give-charity-donations.jpg'

  # Callback
  after_validation :clean_error_duplication

  # Validation
  validates_attachment_size :attachment, less_than: 10.megabyte
  #FIXME_AB: We are not displaying valid attachment types in frontend
  validates_attachment_content_type :attachment, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf", "text/html", "application/doc"], message: "is not valid"
  validate :image_dimensions, if: :is_image

  #FIXME_AB: You should have default value to nil in following method url(size = nil), so that you can call this method without argument if needed. For example in case of documents
  # Fixed
  def url(size = nil)
    if size
      attachment.url(size)
    else
      attachment.url(:original)
    end
  end

  def is_image
    ["image/jpg", "image/jpeg", "image/png", "image/gif"].include?(attachment.content_type)
  end

  private

    #FIXME_AB: Why do we have such a regid restriction. Can't we resize bigger images. I would prefer that we should have only min image size check. Not for max.
    # Fixed: it was a requirement
    def image_dimensions
      if image = self.attachment.queued_for_write[:original]
        dimensions = Paperclip::Geometry.from_file(image.path)
        errors.add(:attachment, "Width must be between 300px to 700px") unless dimensions.width <= 700 && dimensions.width >= 300
        errors.add(:attachment, "Height must be between 300px to 700px") unless dimensions.height <= 700 && dimensions.height >= 300
      end
    end

    def clean_error_duplication
      #FIXME_AB: why :'attachment_file_size' ?
      # Fixed: it is as the key generated in errors hash
      errors.delete(:'attachment_file_size')
    end
end
