KAFKA_BROKER = ENV.fetch('KAFKA_BROKER', 'kafka://localhost:9092')
KAFKA_GROUP = ENV.fetch('KAFKA_GROUP', 'consumer-group')
KAFKA_TOPIC = ENV.fetch('KAFKA_TOPIC', 'example')
AVRO_REGISTRY_URL = ENV['AVRO_REGISTRY_URL']
AVRO_SCHEMA_NAME =  ENV['AVRO_SCHEMA_NAME']
