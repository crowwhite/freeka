class Comment < ActiveRecord::Base
  include Pushable

  attr_accessor :socket_id

  belongs_to :requirement
  belongs_to :user

  validates :content, presence: true

  after_create :notify_via_pusher

  private
    def notify_via_pusher
      send_push_message(requirement.id, 'add_comment', 'A comment has been added', @socket_id)
    end
end
