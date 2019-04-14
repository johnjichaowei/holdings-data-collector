# frozen_string_literal: true

require_relative './errors/finance_data_validation_error'
require_relative './finance_data_client'
require_relative './finance_data_schema'
require_relative './logging'
require_relative './parse_finance_data'

class FinanceDataRepository
  def self.get(holding_symbol)
    finance_data = ParseFinanceData.call(FinanceDataClient.get(holding_symbol))
    validated = FinanceDataSchema.schema.call(finance_data)
    unless validated.errors.empty?
      LOGGER.error("Finance data validation failed with errors: #{validated.errors.to_json}")
      raise FinanceDataValidationError, 'Finance data validation failed'
    end
    validated.output
  end
end
