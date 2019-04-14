# frozen_string_literal: true

require 'holdings_data_collector'

RSpec.describe HoldingsDataCollector do
  subject(:collect) { described_class.call(event: nil, context: nil) }

  before do
    allow(ENVied).to receive(:require)
  end

  it 'loads the env variables' do
    expect(ENVied).to receive(:require).once
    collect
  end
end
