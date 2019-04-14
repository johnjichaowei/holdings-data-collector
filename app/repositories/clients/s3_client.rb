# frozen_string_literal: true

require 'aws-sdk-s3'

class S3Client
  class << self
    def put(key, content, content_type)
      s3_object(key).put(body: content, content_type: content_type)
    end

    private

    def s3_object(key)
      s3.bucket(ENVied.HOLDING_DATA_S3_BUCKET).object(key)
    end

    def s3
      Aws::S3::Resource.new
    end
  end
end
