# frozen_string_literal: true

require 'dry-validation'

class FinanceDataSchema
  def self.schema
    Dry::Validation.Params do
      configure { config.type_specs = true }

      required(:eps_ttm, :decimal).filled(:decimal?)
    end
  end
end
