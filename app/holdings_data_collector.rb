# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'envied'
require 'utils/logging'
require 'errors/holding_message_validation_error'
require 'services/holding_data_collect_service'

class HoldingsDataCollector
  class << self
    def handle(event:, context:)
      ENVied.require
      $LOAD_PATH.unshift(File.expand_path('../app', __dir__))

      LOGGER.info("Processing event: #{event}")
      LOGGER.info("Context: #{context}")
      event['Records'].each { |record| handle_message(record['body']) }
    end

    private

    def handle_message(message)
      parsed_message = HashTransformer.deep_underscore_keys(JSON.parse(message))
      validated = HoldingSchema.schema.call(parsed_message)
      if validated.errors.empty?
        HoldingDataCollectService.call(validated.output)
      else
        LOGGER.error("Holding message validation failed with errors: #{validated.errors.to_json}")
        raise HoldingMessageValidationError, 'Holding message validation failed'
      end
    end
  end
end
