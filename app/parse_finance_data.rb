# frozen_string_literal: true

class ParseFinanceData
  class << self
    def call(raw_text)
      { eps_ttm: parse_eps(raw_text) }
    end

    private

    def parse_eps(raw_text)
      match_data = %r{<td.+?data-test="EPS_RATIO-value".*?><span.*?>(?<eps_text>.*?)</span></td>}.match(raw_text)
      match_data ? match_data[:eps_text] : nil
    end
  end
end
