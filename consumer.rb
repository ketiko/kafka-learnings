#! /usr/bin/env ruby
# frozen_string_literal: true

require 'bundler'
Bundler.require

logger = Logger.new(STDOUT)

begin
  logger.debug 'Starting consumer...'

  begin
    kafka = Kafka.new('kafka://127.0.0.1:9092')

    consumer = kafka.consumer(group_id: 'consumer-group')
    consumer.subscribe('example')

    logger.debug 'Listening for messages...'
    consumer.each_message do |message|
      event = JSON.parse(message.value)
      time = Time.at(event['timestamp'].to_i).strftime('%Y-%m-%d %H:%M:%S %Z')
      logger.debug "Offset: #{message.offset} "\
        "Key: #{message.key} "\
        "Message: #{event['name']} - #{time}"
    end
  ensure
    consumer.stop
  end
rescue SignalException
  logger.debug 'Stopping consumer..'
  exit(0)
end
