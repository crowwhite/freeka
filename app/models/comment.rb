class Comment < ActiveRecord::Base
  include Pushable

  belongs_to :requirement
  belongs_to :user

  after_create :push_comment

  private
    def push_comment
      send_push_message(requirement.id, 'add_comment', { user_name: user.display_name, user_id: user.id, comment: content, time: created_at.to_s })
    end
end
