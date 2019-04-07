# frozen_string_literal: true

require 'holdings_data_collector'

RSpec.describe HoldingsDataCollector do
  subject(:collect) { described_class.call(event: nil, context: nil) }

  let(:url) { 'https://jsonplaceholder.typicode.com/posts/1' }
  let(:response) { instance_double(Faraday::Response) }

  before do
    allow(Faraday).to receive(:get).and_return(response)
  end

  it 'dummy test 1 - calls Faraday' do
    expect(Faraday).to receive(:get).with(url).once
    collect
  end

  it 'dummy test 2 - returns the response' do
    expect(collect).to eq(response)
  end
end
