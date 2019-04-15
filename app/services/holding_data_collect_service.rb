# frozen_string_literal: true

require 'models/holding_data'
require 'repositories/finance_data_repository'
require 'repositories/holding_data_repository'

class HoldingDataCollectService
  class << self
    def call(holding)
      finance_data = FinanceDataRepository.get(holding[:symbol])
      holding_data = HoldingData.build(holding, finance_data)
      HoldingDataRepository.save(holding_data)
    end
  end
end
