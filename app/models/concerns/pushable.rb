module Pushable
  extend ActiveSupport::Concern

  included do
    def send_push_message(channel_name, event_name, data, socket_id)
      Pusher.trigger("channel_#{ channel_name }", event_name, data, { socket_id: socket_id.to_s })
    end
  end
end