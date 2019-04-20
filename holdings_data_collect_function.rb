# frozen_string_literal: true

require_relative './system/boot'
require_relative './app/holdings_data_collector'

def handler(event:, context:)
  HoldingsDataCollector.handle(event: event, context: context)
end
