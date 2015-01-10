class Comment < ActiveRecord::Base
  include Pushable

  attr_accessor :socket_id

  # Associations
  belongs_to :requirement
  belongs_to :user

  # Validations
  validates :content, presence: true
  validates :content, length:  { minimum: 1, maximum: 500 }, allow_blank: true

  # Callbacks
  after_create :notify_via_pusher

  private
    def notify_via_pusher
      send_push_message(requirement.id, 'add_comment', 'A comment has been added', @socket_id)
    end
end
