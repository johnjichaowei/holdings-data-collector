# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'envied'
require_relative './logging'

class HoldingsDataCollector
  def self.call(event:, context:)
    ENVied.require

    LOGGER.info("Event: #{event}")
    LOGGER.info("Context: #{context}")
  end
end
