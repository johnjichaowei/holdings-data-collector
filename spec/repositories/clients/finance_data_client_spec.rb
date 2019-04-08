# frozen_string_literal: true

require 'repositories/clients/finance_data_client'

RSpec.describe FinanceDataClient do
  subject(:get) { described_class.get(holding_symbol) }

  let(:base_url) { 'https://dummy-finance.com' }
  let(:holding_symbol) { 'CBA' }
  let(:expected_url) { "#{base_url}/quote/#{holding_symbol}.AX" }
  let(:response_code) { 200 }
  let(:response_body) { 'bla' }

  before do
    allow(ENVied).to receive(:FINANCE_DATA_HOST_URL).and_return(base_url)
    stub_request(:get, expected_url).to_return(body: response_body, status: response_code)
  end

  it 'sends one http GET request to retrieve the finance data' do
    get
    expect(a_request(:get, expected_url)).to have_been_made.once
  end

  it 'returns the response body' do
    expect(get).to eq(response_body)
  end

  context 'when there is one 500 response received' do
    let(:response_code) { 500 }

    it 'raises exception' do
      expect { get }.to raise_error(Faraday::Error)
    end
  end
end
