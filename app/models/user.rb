class User < Person
  devise :registerable

  scope :with_email_like, ->(email) { where("email LIKE CONCAT('%', ?, '%')", email) }
  scope :with_name_like, ->(name) { where("name LIKE CONCAT('%', ?, '%')", name) }
  scope :active, -> { where enabled: true }
  scope :inactive, -> { where enabled: false }

  has_many :comments, dependent: :destroy
  has_one :image, as: :attacheable, dependent: :destroy, class_name: :Attachment

  accepts_nested_attributes_for :image
end
