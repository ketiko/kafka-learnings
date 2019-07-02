# frozen_string_literal: true

# Non Ruby on Rails setup
ENV['RACK_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] ||= ENV['RACK_ENV']
Bundler.require(:default, ENV['KARAFKA_ENV'])
Karafka::Loader.load(Karafka::App.root)

require 'dotenv/load'
require_relative './constants'

# Ruby on Rails setup
# Remove whole non-Rails setup that is above and uncomment the 4 lines below
# ENV['RAILS_ENV'] ||= 'development'
# ENV['KARAFKA_ENV'] = ENV['RAILS_ENV']
# require ::File.expand_path('../config/environment', __FILE__)
# Rails.application.eager_load!

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka.seed_brokers = KAFKA_BROKER
    config.client_id = 'test-app'
    config.backend = :inline
    config.batch_fetching = true
    # Uncomment this for Rails app integration
    config.logger = Logger.new(STDOUT)
  end

  after_init do |config|
    # Put here all the things you want to do after the Karafka framework
    # initialization
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(Karafka::Instrumentation::Listener)

  consumer_groups.draw do
    consumer_group KAFKA_GROUP do
      topic KAFKA_TOPIC do
        consumer ExampleConsumer
      end
    end

    # consumer_group :bigger_group do
    #   topic :test do
    #     consumer TestConsumer
    #   end
    #
    #   topic :test2 do
    #     consumer Test2Consumer
    #   end
    # end
  end
end

KarafkaApp.boot!
