# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry::Types.module
end

class HoldingData < Dry::Struct::Value
  attribute :symbol, Types::Strict::String
  attribute :name, Types::Strict::String.optional.meta(omittable: true)
  attribute :sector_name, Types::Strict::String.optional.meta(omittable: true)
  attribute :etf_data do
    attribute :numberofshares, Types::Strict::Decimal
    attribute :market_value, Types::Strict::Decimal
    attribute :market_val_percent, Types::Strict::Decimal
  end
  attribute :finance_data do
    attribute :eps_ttm, Types::Strict::Decimal
  end

  def self.build(holding, finance_data)
    HoldingData.new(
      symbol: holding[:symbol], name: holding[:holding], sector_name: holding[:sector_name],
      etf_data: {
        numberofshares: holding[:numberofshares],
        market_value: holding[:market_value],
        market_val_percent: holding[:market_val_percent]
      },
      finance_data: { eps_ttm: finance_data[:eps_ttm] }
    )
  end
end
