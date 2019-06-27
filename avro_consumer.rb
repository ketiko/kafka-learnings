#! /usr/bin/env ruby

# frozen_string_literal: true

require 'bundler'
Bundler.require

require 'avro_turf/messaging'

require 'dotenv/load'
require_relative './constants'

logger = Logger.new(STDOUT)

begin
  logger.debug 'Starting avro consumer...'

  kafka = Kafka.new(
    KAFKA_BROKER,
    logger: logger,
    ssl_ca_certs_from_system: true,
    sasl_plain_username: KAFKA_USERNAME,
    sasl_plain_password: KAFKA_PASSWORD
  )

  begin
    avro = AvroTurf::Messaging.new(registry_url: AVRO_REGISTRY_URL)

    logger.debug "Topics: #{kafka.topics}"

    # consumer = kafka.consumer(group_id: KAFKA_GROUP)
    # consumer.subscribe(KAFKA_TOPIC)
    #
    # begin
    #   logger.debug 'Listening for messages...'
    #   consumer.each_message do |message|
    #     event = avro.decode(message.value, schema_name: AVRO_SCHEMA_NAME)
    #
    #     logger.debug "Offset: #{message.offset} "\
    #       "Key: #{message.key} "\
    #       "Message: #{event}"
    #   end
    # ensure
    #   consumer.stop
    # end
  ensure
    kafka.close
  end
rescue SignalException
  logger.debug 'Stopping avro consumer..'
  exit(0)
end
