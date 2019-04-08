# frozen_string_literal: true

require 'faraday'

class FinanceDataClient
  class << self
    def get(holding_symbol)
      connection.get("/quote/#{holding_symbol}.AX").body
    end

    private

    def connection
      Faraday.new(url: ENVied.FINANCE_DATA_HOST_URL) do |conn|
        conn.response :raise_error
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
