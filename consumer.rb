#! /usr/bin/env ruby
# frozen_string_literal: true

require 'bundler'
Bundler.require

require 'dotenv/load'
require_relative './constants'

logger = Logger.new(STDOUT)

begin
  logger.debug 'Starting consumer...'

  kafka = Kafka.new(KAFKA_BROKER)

  begin
    consumer = kafka.consumer(group_id: KAFKA_GROUP)
    consumer.subscribe(KAFKA_TOPIC)

    begin
      logger.debug 'Listening for messages...'
      consumer.each_message do |message|
        event = JSON.parse(message.value)
        time = Time.at((event['timestamp'].to_f / 1_000)).strftime('%Y-%m-%d %H:%M:%S:%L %Z')

        logger.debug "Offset: #{message.offset} "\
          "Key: #{message.key} "\
          "Message: #{event['name']} - #{time}"
      end
    ensure
      consumer.stop
    end
  ensure
    kafka.close
  end
rescue SignalException
  logger.debug 'Stopping consumer..'
  exit(0)
end
