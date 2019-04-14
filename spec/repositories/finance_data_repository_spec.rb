# frozen_string_literal: true

require 'repositories/finance_data_repository'

RSpec.describe FinanceDataRepository do
  subject(:get) { described_class.get(holding_symbol) }

  let(:holding_symbol) { 'CBA' }
  let(:finance_data_text) { '<html></html>' }
  let(:parsed_finance_data) { { eps_ttm: '2.12' } }
  let(:finance_data_schema) { instance_double(Dry::Validation::Schema) }
  let(:validation_output) { { eps_ttm: BigDecimal('2.12') } }
  let(:validation_errors) { {} }
  let(:validated) do
    instance_double(
      Dry::Validation::Result,
      output: validation_output,
      errors: validation_errors
    )
  end

  before do
    allow(FinanceDataClient).to receive(:get).and_return(finance_data_text)
    allow(ParseFinanceData).to receive(:call).and_return(parsed_finance_data)
    allow(FinanceDataSchema).to receive(:schema).and_return(finance_data_schema)
    allow(finance_data_schema).to receive(:call).and_return(validated)
  end

  it 'calls finance data client to retrieve the fiance data' do
    expect(FinanceDataClient).to receive(:get).with(holding_symbol).once
    get
  end

  it 'parses the retrieved finance data text' do
    expect(ParseFinanceData).to receive(:call).with(finance_data_text).once
    get
  end

  it 'validates the parsed finance data' do
    expect(finance_data_schema).to receive(:call).with(parsed_finance_data).once
    get
  end

  it 'returns the validated finance data' do
    expect(get).to eq(validation_output)
  end

  context 'when the parsed finance data is invalidate' do
    let(:validation_errors) { { eps_ttm: ['must be a decimal'] } }
    let(:validation_output) { {} }

    before do
      allow(LOGGER).to receive(:error)
    end

    it 'raises exception' do
      expect { get }.to raise_error(FinanceDataValidationError, 'Finance data validation failed')
    end

    it 'logs the errors' do
      expect(LOGGER).to receive(:error).with(
        "Finance data validation failed with errors: #{validated.errors.to_json}"
      ).once
      get rescue nil
    end
  end
end
