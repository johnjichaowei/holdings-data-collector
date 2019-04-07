# frozen_string_literal: true

require 'dry-validation'

class HoldingMessageSchema
  def self.schema # rubocop:disable Metrics/AbcSize
    Dry::Validation.Params do
      configure { config.type_specs = true }

      optional(:holding, :string).filled(:str?)
      required(:symbol, :string).filled(:str?)
      optional(:sector_name, :string).maybe(:str?)
      required(:numberofshares, :decimal).filled(:decimal?)
      required(:market_value, :decimal).filled(:decimal?)
      required(:market_val_percent, :decimal).filled(:decimal?)
    end
  end
end
