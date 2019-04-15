# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string/inflections.rb'

class HashTransformer
  class << self
    def deep_underscore_keys(hash)
      deep_transform_keys(hash, &:underscore)
    end

    def deep_camelize_keys(hash)
      deep_transform_keys(hash) do |key|
        key = key.instance_of?(Symbol) ? key.to_s : key
        key.camelize(:lower)
      end
    end

    private

    def deep_transform_keys(hash, &block)
      hash.each_value { |value| deep_transform_keys(value, &block) if value.instance_of?(Hash) }
      hash.transform_keys! { |key| yield key }
    end
  end
end
