# frozen_string_literal: true

require 'schemas/finance_data_schema'

RSpec.describe FinanceDataSchema do
  subject(:validated) { described_class.schema.call(finance_data) }

  let(:finance_data) { nil }

  describe 'validates the eps_ttm field' do
    let(:finance_data) { { eps_ttm: '14541892.0' } }

    it 'accepts decimal number value' do
      expect(validated.errors).not_to include(:eps_ttm)
    end

    context 'when eps_ttm is not a number' do
      let(:finance_data) { { eps_ttm: 'bla123' } }

      it 'returns error' do
        expect(validated.errors).to include(eps_ttm: ['must be a decimal'])
      end
    end

    context 'when eps_ttm is absent' do
      let(:finance_data) { {} }

      it 'returns error' do
        expect(validated.errors).to include(eps_ttm: ['is missing'])
      end
    end

    context 'when eps_ttm is nil' do
      let(:finance_data) { { eps_ttm: nil } }

      it 'returns error' do
        expect(validated.errors).to include(eps_ttm: ['must be filled'])
      end
    end

    context 'when eps_ttm is empty' do
      let(:finance_data) { { eps_ttm: '' } }

      it 'is valid' do
        expect(validated.errors).to include(eps_ttm: ['must be filled'])
      end
    end
  end
end
