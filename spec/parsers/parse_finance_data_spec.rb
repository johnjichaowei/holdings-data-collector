# frozen_string_literal: true

require 'parsers/parse_finance_data'

RSpec.describe ParseFinanceData do
  subject(:finance_data) { described_class.call(raw_text) }

  let(:eps_tag_text) { 'EPS_RATIO-value' }
  let(:eps_value_text) { '2.12' }
  let(:raw_text) do
    <<-RAW_TEXT
      <!DOCTYPE html>
      <html lang="en-AU">
      <body>
      <div>
      <table class="W(100%) M(0) Bdcl(c)" data-reactid="49">
      <tbody data-reactid="50">
        <tr class="Bxz(bb) Bdbw(1px) Bdbs(s) Bdc($c-fuji-grey-c) H(36px) " data-reactid="66">
          <td class="C(black) W(51%)" data-reactid="67"><span data-reactid="68">EPS (TTM)</span></td>
          <td class="Lh(14px)" data-test="#{eps_tag_text}" data-reactid="69"><span class="Trsdu(0.3s)">#{eps_value_text}</span></td>
        </tr>
        <tr class="Bxz(bb) Bdbw(1px) Bdbs(s) Bdc($c-fuji-grey-c) H(36px) " data-reactid="71">
          <td class="C(black) W(51%)" data-reactid="72"><span data-reactid="73">Earnings date</span></td>
          <td class="Ta(end) Fw(600) Lh(14px)" data-test="EARNINGS_DATE-value" data-reactid="74"><span data-reactid="75">1 May 2019</span></td>
        </tr>
      </tbody>
      </table>
      </div>
      </body>
      </html>
    RAW_TEXT
  end

  it 'returns the eps value in the pared finance data' do
    expect(finance_data[:eps_ttm]).to eq '2.12'
  end

  context 'when the eps tag does not exist in the raw text' do
    let(:eps_tag_text) { '' }

    it 'retuns the eps value as nil' do
      expect(finance_data[:eps_ttm]).to eq nil
    end
  end
end
