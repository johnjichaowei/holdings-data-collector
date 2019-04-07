# frozen_string_literal: true

require 'simplecov'

if ENV['COVERAGE'] == 'true'
  SimpleCov.start do
    add_filter 'spec'
    minimum_coverage 100
  end
end

ENV['APP_ENV'] ||= 'test'
$LOAD_PATH.unshift(File.expand_path('../app', __dir__))

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  config.example_status_persistence_file_path = 'spec/examples.txt'

  config.disable_monkey_patching!

  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed
end