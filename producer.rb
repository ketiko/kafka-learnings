#! /usr/bin/env ruby
# frozen_string_literal: true

require 'bundler'
Bundler.require

require 'logger'
logger = Logger.new(STDOUT)

begin
  logger.debug 'Starting producer...'

  WaterDrop.setup do |config|
    config.deliver = true
    config.logger = logger
    config.kafka.seed_brokers = %w[kafka://localhost:9092]
  end

  while true
    puts 'Publish a new message? (Y/n)'
    if gets.chomp.strip.downcase == 'n'
      break
    end

    logger.debug 'Publishing new message'
    WaterDrop::SyncProducer.call({message: "Example Message #{Time.now} #{Time.now.to_i}"}.to_json, topic: 'example')
  end

rescue SignalException
  logger.debug 'Stopping producer..'
  exit(0)
end
