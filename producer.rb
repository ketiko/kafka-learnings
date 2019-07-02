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
  end

  while true
    puts 'Publish a new message? (Y/n)'
    break if gets.chomp.strip.downcase == 'n'

    logger.debug 'Publishing new message'
    event = {
      name: 'Example Message',
      timestamp: Time.now.to_f * 1_000
    }
    # partition = rand(2) % 2
    partition = 0
    WaterDrop::SyncProducer.call(event.to_json, topic: KAFKA_TOPIC, partition: partition)
  end
rescue SignalException
  logger.debug 'Stopping producer..'
  exit(0)
end
