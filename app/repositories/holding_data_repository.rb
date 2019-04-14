# frozen_string_literal: true

require 'models/holding_data'
require_relative 'clients/s3_client'

class HoldingDataRepository
  class << self
    def save(holding_data)
      S3Client.put(s3_object_key(holding_data), content(holding_data), content_type)
    end

    private

    def s3_object_key(holding_data)
      "#{Date.today.iso8601}/#{holding_data.symbol}.json"
    end

    def content(holding_data)
      holding_data.to_hash.to_json
    end

    def content_type
      'application/json'
    end
  end
end
