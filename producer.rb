#! /usr/bin/env ruby
# frozen_string_literal: true

require 'bundler'
Bundler.require

require 'dotenv/load'
require_relative './constants'

logger = Logger.new(STDOUT)

begin
  logger.debug 'Starting producer...'

  WaterDrop.setup do |config|
    config.deliver = true
    config.logger = logger
    config.kafka.seed_brokers = Array(KAFKA_BROKER)
    if KAFKA_PASSWORD
      config.kafka.ssl_ca_certs_from_system = true
      config.kafka.sasl_plain_username = KAFKA_USERNAME
      config.kafka.sasl_plain_password = KAFKA_PASSWORD
    end
  end

  while true
    puts 'Publish a new message? (Y/n)'
    break if gets.chomp.strip.downcase == 'n'

    logger.debug 'Publishing new message'
    event = {
      name: 'Example Message',
      timestamp: Time.now.to_f * 1_000
    }
    WaterDrop::SyncProducer.call(event.to_json, topic: KAFKA_TOPIC)
  end
rescue SignalException
  logger.debug 'Stopping producer..'
  exit(0)
end
