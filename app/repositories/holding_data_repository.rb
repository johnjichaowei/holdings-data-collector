# frozen_string_literal: true

require 'models/holding_data'
require 'utils/hash_transformer'
require 'utils/logging'
require_relative 'clients/s3_client'

class HoldingDataRepository
  class << self
    def save(holding_data)
      key = s3_object_key(holding_data.symbol)
      content = s3_content(holding_data)
      LOGGER.info("Saving holding data to S3, key: #{key}, content: #{content}")
      S3Client.put(key, content, content_type)
    end

    private

    def s3_object_key(holding_symbol)
      "#{Date.today.iso8601}/#{holding_symbol}.json"
    end

    def s3_content(holding_data)
      HashTransformer.deep_camelize_keys(holding_data.to_hash).to_json
    end

    def content_type
      'application/json'
    end
  end
end
