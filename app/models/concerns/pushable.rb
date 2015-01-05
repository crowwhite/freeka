module Pushable
  extend ActiveSupport::Concern

  included do
    def send_push_message(channel_name, event_name, data)
      Pusher.trigger("channel_#{ channel_name }", event_name, data)
    end
  end
end