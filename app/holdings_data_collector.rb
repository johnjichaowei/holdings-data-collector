# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'faraday'

class HoldingsDataCollector
  def self.call(event:, context:)
    Faraday.get 'https://jsonplaceholder.typicode.com/posts/1'
  end
end