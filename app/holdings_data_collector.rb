# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'envied'
require 'utils/logging'

class HoldingsDataCollector
  def self.call(event:, context:)
    ENVied.require
    $LOAD_PATH.unshift(File.expand_path('../app', __dir__))

    LOGGER.info("Event: #{event}")
    LOGGER.info("Context: #{context}")
  end
end
