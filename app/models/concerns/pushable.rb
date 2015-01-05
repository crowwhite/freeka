module Pushable
  extend ActiveSupport::Concern

  included do
    def send_push_message(requirement_id, event_name, data)
      Pusher.trigger("channel_#{ requirement_id }", event_name, data)
    end
  end
end