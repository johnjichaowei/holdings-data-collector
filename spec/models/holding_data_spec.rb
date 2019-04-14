# frozen_string_literal: true

require 'models/holding_data'

RSpec.describe HoldingData do
  subject(:holding_data) { described_class.build(holding, finance_data) }

  let(:holding) do
    {
      symbol: 'CBA',
      holding: 'Commonwealth Bank of Australia',
      sector_name: 'Diversified Banks',
      numberofshares: BigDecimal('14389879'),
      market_value: BigDecimal('1041683340.81'),
      market_val_percent: BigDecimal('8.25647')
    }
  end
  let(:finance_data) { { eps_ttm: BigDecimal('4.62') } }
  let(:expected_holding_data) do
    {
      symbol: 'CBA',
      name: 'Commonwealth Bank of Australia',
      sector_name: 'Diversified Banks',
      etf_data: {
        numberofshares: BigDecimal('14389879'),
        market_value: BigDecimal('1041683340.81'),
        market_val_percent: BigDecimal('8.25647')
      },
      finance_data: {
        eps_ttm: BigDecimal('4.62')
      }
    }
  end

  it('returns the holding_data') do
    expect(holding_data.to_hash).to eq(expected_holding_data)
  end
end
