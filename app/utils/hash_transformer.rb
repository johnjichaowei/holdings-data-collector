# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string/inflections.rb'

class HashTransformer
  class << self
    def deep_underscore_keys(hash)
      hash.each_value { |value| deep_underscore_keys(value) if value.instance_of?(Hash) }
      hash.transform_keys!(&:underscore)
    end
  end
end
