KAFKA_BROKER = ENV.fetch('KAFKA_BROKER', 'localhost:9092').split(',').map { |l| "kafka://#{l}" }
KAFKA_GROUP = ENV.fetch('KAFKA_GROUP', 'consumer-group')
KAFKA_TOPIC = ENV.fetch('KAFKA_TOPIC', 'example')
KAFKA_USERNAME = ENV['KAFKA_USERNAME']
KAFKA_PASSWORD = ENV['KAFKA_PASSWORD']
AVRO_REGISTRY_URL = ENV['AVRO_REGISTRY_URL']
AVRO_SCHEMA_NAME =  ENV['AVRO_SCHEMA_NAME']
