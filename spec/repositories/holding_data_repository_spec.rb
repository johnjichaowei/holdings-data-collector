# frozen_string_literal: true

require 'repositories/holding_data_repository'

RSpec.describe HoldingDataRepository do
  subject(:save) { described_class.save(holding_data) }

  let(:holding_data) do
    HoldingData.new(
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
    )
  end
  let(:today) { Date.new(2019, 0o4, 15) }
  let(:s3_object_key) { "#{today}/CBA.json" }
  let(:holding_data_json) do
    {
      symbol: 'CBA',
      name: 'Commonwealth Bank of Australia',
      sectorName: 'Diversified Banks',
      etfData: {
        numberofshares: BigDecimal('14389879'),
        marketValue: BigDecimal('1041683340.81'),
        marketValPercent: BigDecimal('8.25647')
      },
      financeData: {
        epsTtm: BigDecimal('4.62')
      }
    }.to_json
  end
  let(:content_type) { 'application/json' }

  before do
    allow(Date).to receive(:today).and_return(today)
    allow(S3Client).to receive(:put)
  end

  it 'saves the holding data to S3' do
    expect(S3Client).to receive(:put).with(
      s3_object_key, holding_data_json, content_type
    ).once
    save
  end
end
