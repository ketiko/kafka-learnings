#! /usr/bin/env ruby
# frozen_string_literal: true

require 'bundler'
Bundler.require

require 'dotenv/load'
require_relative './constants'

logger = Logger.new(STDOUT)

begin
  logger.debug 'Starting consumer...'

  begin
    kafka = Kafka.new(KAFKA_BROKER)

    consumer = kafka.consumer(group_id: KAFKA_GROUP)
    consumer.subscribe(KAFKA_TOPIC)

    avro = AvroTurf::Messaging.new(registry_url: AVRO_REGISTRY_URL)

    logger.debug 'Listening for messages...'
    consumer.each_message do |message|
      event = avro.decode(message.value, schema_name: AVRO_SCHEMA_NAME)

      logger.debug "Offset: #{message.offset} "\
        "Key: #{message.key} "\
        "Message: #{event}"
    end
  ensure
    consumer.stop
  end
rescue SignalException
  logger.debug 'Stopping consumer..'
  exit(0)
end
