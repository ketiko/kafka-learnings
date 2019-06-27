#! /usr/bin/env ruby
# frozen_string_literal: true

require 'bundler'
Bundler.require

require 'logger'
logger = Logger.new(STDOUT)

begin
  logger.debug 'Starting consumer...'

  kafka = Kafka.new('kafka://127.0.0.1:9092')

  logger.debug 'Listening for messages...'
  kafka.each_message(topic: 'example') do |message|
    logger.debug "#{message.offset} #{message.key} #{message.value}"
  end
rescue SignalException
  logger.debug 'Stopping consumer..'
  exit(0)
end
