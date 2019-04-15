# frozen_string_literal: true

require 'errors/finance_data_validation_error'
require 'schemas/finance_data_schema'
require 'utils/logging'
require 'parsers/parse_finance_data'
require_relative './clients/finance_data_client'

class FinanceDataRepository
  def self.get(holding_symbol)
    LOGGER.info("Getting finance data for #{holding_symbol}")
    finance_data = ParseFinanceData.call(FinanceDataClient.get(holding_symbol))
    validated = FinanceDataSchema.schema.call(finance_data)
    unless validated.errors.empty?
      LOGGER.error("Finance data validation failed with errors: #{validated.errors.to_json}")
      raise FinanceDataValidationError, 'Finance data validation failed'
    end
    validated.output
  end
end
