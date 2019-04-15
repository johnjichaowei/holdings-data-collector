# frozen_string_literal: true

require 'holdings_data_collector'

RSpec.describe HoldingsDataCollector do
  subject(:handle) { described_class.handle(event: event, context: nil) }

  let(:event) do
    {
      'Records' => [
        { 'messageId' => '059f36b4-87a3-44ab-83d2-661975830a7d',
          'body' => holding_message }
      ]
    }
  end
  let(:holding_message) { holding_hash.to_json }
  let(:holding_hash) do
    {
      'holding' => 'Australia & New Zealand Banking Group Ltd.',
      'symbol' => 'ANZ',
      'sectorName' => 'Diversified Banks',
      'marketValPercent' => '4.82065',
      'marketValue' => '669711812.0',
      'numberofshares' => '23918279.0'
    }
  end
  let(:parsed_holding_hash) do
    {
      'holding' => 'Australia & New Zealand Banking Group Ltd.',
      'symbol' => 'ANZ',
      'sector_name' => 'Diversified Banks',
      'market_val_percent' => '4.82065',
      'market_value' => '669711812.0',
      'numberofshares' => '23918279.0'
    }
  end
  let(:holding_schema) { instance_double(Dry::Validation::Schema) }
  let(:validation_output) { { foo: 'bar' } }
  let(:validation_errors) { {} }
  let(:validated) do
    instance_double(
      Dry::Validation::Result,
      output: validation_output,
      errors: validation_errors
    )
  end

  before do
    allow(ENVied).to receive(:require)
    allow(HoldingSchema).to receive(:schema).and_return(holding_schema)
    allow(holding_schema).to receive(:call).and_return(validated)
    allow(HoldingDataCollectService).to receive(:call)
  end

  it 'loads the env variables' do
    expect(ENVied).to receive(:require).once
    handle
  end

  it 'validate the parsed holding message' do
    expect(holding_schema).to receive(:call).with(parsed_holding_hash).once
    handle
  end

  it 'calls holding data collect service to process the holding message' do
    expect(HoldingDataCollectService).to receive(:call).with(validation_output).once
    handle
  end

  context 'when the incoming holding message is invalid' do
    let(:validation_errors) { { field_name: ['some error'] } }

    before do
      allow(LOGGER).to receive(:error)
    end

    it 'raises exception' do
      expect { handle }.to raise_error(HoldingMessageValidationError, 'Holding message validation failed')
    end

    it 'logs the error' do
      expect(LOGGER).to receive(:error).with(
        "Holding message validation failed with errors: #{validation_errors.to_json}"
      ).once
      handle rescue nil
    end
  end
end
