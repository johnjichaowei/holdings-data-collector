# frozen_string_literal: true

require 'services/holding_data_collect_service'

RSpec.describe HoldingDataCollectService do
  subject(:collect) { described_class.call(holding_hash) }

  let(:holding_symbol) { 'ANZ' }
  let(:holding_hash) do
    {
      holding: 'Australia & New Zealand Banking Group Ltd.',
      symbol: holding_symbol,
      sector_name: 'Diversified Banks',
      market_val_percent: '4.82065',
      market_value: '669711812.0',
      numberofshares: '23918279.0'
    }
  end
  let(:finance_data) { { eps_ttm: BigDecimal('2.12') } }
  let(:holding_data) { instance_double(HoldingData) }

  before do
    allow(FinanceDataRepository).to receive(:get).and_return(finance_data)
    allow(HoldingData).to receive(:build).and_return(holding_data)
    allow(HoldingDataRepository).to receive(:save)
  end

  it 'retrieves finance data with finance data repository' do
    expect(FinanceDataRepository).to receive(:get).with(holding_symbol).once
    collect
  end

  it 'builds the holding data model' do
    expect(HoldingData).to receive(:build).with(holding_hash, finance_data).once
    collect
  end

  it 'saves the holding data with holding data repository' do
    expect(HoldingDataRepository).to receive(:save).with(holding_data).once
    collect
  end
end
