# frozen_string_literal: true

require 'utils/hash_transformer'

RSpec.describe HashTransformer do
  describe '.deep_underscore_keys' do
    subject(:transformed) { described_class.deep_underscore_keys(hash) }

    let(:hash) do
      { 'camelCase' => 'valueAbc', 'nextLevel' => { 'camelCaseAgain' => 'valueNextLevel' } }
    end
    let(:expected_result) do
      { 'camel_case' => 'valueAbc', 'next_level' => { 'camel_case_again' => 'valueNextLevel' } }
    end

    it 'deep transforms the hash keys to underscore' do
      expect(transformed).to eq(expected_result)
    end
  end

  describe '.deep_camelize_keys' do
    subject(:transformed) { described_class.deep_camelize_keys(hash) }

    let(:hash) do
      { 'camel_case' => 'valueAbc', 'next_level' => { 'camel_case_again' => 'valueNextLevel' } }
    end
    let(:expected_result) do
      { 'camelCase' => 'valueAbc', 'nextLevel' => { 'camelCaseAgain' => 'valueNextLevel' } }
    end

    it 'deep transforms the hash keys to camel case' do
      expect(transformed).to eq(expected_result)
    end

    context 'when the input hash keys are symbols' do
      let(:hash) do
        { camel_case: 'valueAbc', next_level: { camel_case_again: 'valueNextLevel' } }
      end

      it 'deep transforms the hash keys to camel case' do
        expect(transformed).to eq(expected_result)
      end
    end
  end
end
