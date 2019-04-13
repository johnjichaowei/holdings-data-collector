# frozen_string_literal: true

require 'holding_schema'

RSpec.describe HoldingSchema do
  subject(:valiated) { described_class.schema.call(holding_hash) }

  let(:holding_hash) { nil }

  describe 'validates the holding field' do
    let(:holding_hash) { { holding: 'CBA' } }

    it 'accepts string value' do
      expect(valiated.errors).not_to include(:holding)
    end

    context 'when holding is absent' do
      let(:holding_hash) { {} }

      it 'is valid' do
        expect(valiated.errors).not_to include(:holding)
      end
    end

    context 'when holding is nil' do
      let(:holding_hash) { { holding: nil } }

      it 'returns error' do
        expect(valiated.errors).to include(holding: ['must be filled'])
      end
    end

    context 'when holding is empty' do
      let(:holding_hash) { { holding: '' } }

      it 'returns error' do
        expect(valiated.errors).to include(holding: ['must be filled'])
      end
    end
  end

  describe 'validates the symbol field' do
    let(:holding_hash) { { symbol: 'CBA' } }

    it 'accepts string value' do
      expect(valiated.errors).not_to include(:symbol)
    end

    context 'when symbol is absent' do
      let(:holding_hash) { {} }

      it 'returns error' do
        expect(valiated.errors).to include(symbol: ['is missing'])
      end
    end

    context 'when symbol is nil' do
      let(:holding_hash) { { symbol: nil } }

      it 'returns error' do
        expect(valiated.errors).to include(symbol: ['must be filled'])
      end
    end

    context 'when symbol is empty' do
      let(:holding_hash) { { symbol: '' } }

      it 'returns error' do
        expect(valiated.errors).to include(symbol: ['must be filled'])
      end
    end
  end

  describe 'validates the sector name field' do
    let(:holding_hash) { { sector_name: 'Diversified Banks' } }

    it 'accepts string value' do
      expect(valiated.errors).not_to include(:sector_name)
    end

    context 'when sector name is absent' do
      let(:holding_hash) { {} }

      it 'is valid' do
        expect(valiated.errors).not_to include(:sector_name)
      end
    end

    context 'when sector name is nil' do
      let(:holding_hash) { { sector_name: nil } }

      it 'is valid' do
        expect(valiated.errors).not_to include(:sector_name)
      end
    end

    context 'when sector name is empty' do
      let(:holding_hash) { { sector_name: '' } }

      it 'is valid' do
        expect(valiated.errors).not_to include(:sector_name)
      end
    end
  end

  describe 'validates the numberofshares field' do
    let(:holding_hash) { { numberofshares: '14541892.0' } }

    it 'accepts decimal number value' do
      expect(valiated.errors).not_to include(:numberofshares)
    end

    context 'when numberofshares is not a number' do
      let(:holding_hash) { { numberofshares: 'bla123' } }

      it 'returns error' do
        expect(valiated.errors).to include(numberofshares: ['must be a decimal'])
      end
    end

    context 'when numberofshares is absent' do
      let(:holding_hash) { {} }

      it 'returns error' do
        expect(valiated.errors).to include(numberofshares: ['is missing'])
      end
    end

    context 'when numberofshares is nil' do
      let(:holding_hash) { { numberofshares: nil } }

      it 'returns error' do
        expect(valiated.errors).to include(numberofshares: ['must be filled'])
      end
    end

    context 'when numberofshares is empty' do
      let(:holding_hash) { { numberofshares: '' } }

      it 'is valid' do
        expect(valiated.errors).to include(numberofshares: ['must be filled'])
      end
    end
  end

  describe 'validates the market value field' do
    let(:holding_hash) { { market_value: '14541892.0' } }

    it 'accepts decimal number value' do
      expect(valiated.errors).not_to include(:market_value)
    end

    context 'when market value is not a number' do
      let(:holding_hash) { { market_value: 'bla123' } }

      it 'returns error' do
        expect(valiated.errors).to include(market_value: ['must be a decimal'])
      end
    end

    context 'when market value is absent' do
      let(:holding_hash) { {} }

      it 'returns error' do
        expect(valiated.errors).to include(market_value: ['is missing'])
      end
    end

    context 'when market value is nil' do
      let(:holding_hash) { { market_value: nil } }

      it 'returns error' do
        expect(valiated.errors).to include(market_value: ['must be filled'])
      end
    end

    context 'when market value is empty' do
      let(:holding_hash) { { market_value: '' } }

      it 'is valid' do
        expect(valiated.errors).to include(market_value: ['must be filled'])
      end
    end
  end

  describe 'validates the market val percent field' do
    let(:holding_hash) { { market_val_percent: '14541892.0' } }

    it 'accepts decimal number value' do
      expect(valiated.errors).not_to include(:market_val_percent)
    end

    context 'when market val percent is not a number' do
      let(:holding_hash) { { market_val_percent: 'bla123' } }

      it 'returns error' do
        expect(valiated.errors).to include(market_val_percent: ['must be a decimal'])
      end
    end

    context 'when market val percent is absent' do
      let(:holding_hash) { {} }

      it 'returns error' do
        expect(valiated.errors).to include(market_val_percent: ['is missing'])
      end
    end

    context 'when market val percent is nil' do
      let(:holding_hash) { { market_val_percent: nil } }

      it 'returns error' do
        expect(valiated.errors).to include(market_val_percent: ['must be filled'])
      end
    end

    context 'when market val percent is empty' do
      let(:holding_hash) { { market_val_percent: '' } }

      it 'is valid' do
        expect(valiated.errors).to include(market_val_percent: ['must be filled'])
      end
    end
  end
end
