# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'faraday'
require_relative './logging'

class HoldingsDataCollector
  def self.call(event:, context:)
    LOGGER.info("Event: #{event}")
    LOGGER.info("Context: #{context}")

    Faraday.get 'https://jsonplaceholder.typicode.com/posts/1'
  end
end
