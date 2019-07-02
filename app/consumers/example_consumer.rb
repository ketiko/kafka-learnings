# frozen_string_literal: true

# Application consumer from which all Karafka consumers should inherit
# You can rename it if it would conflict with your current code base (in case you're integrating
# Karafka with other frameworks)
class ExampleConsumer < ApplicationConsumer
  def consume
    time = Time.at((params['timestamp'].to_f / 1_000)).strftime('%Y-%m-%d %H:%M:%S:%L %Z')

    Karafka.logger.debug "Offset: #{params['offset']} "\
      "Key: #{params['key']} "\
      "Message: #{params['name']} - #{time}"
  end
end
