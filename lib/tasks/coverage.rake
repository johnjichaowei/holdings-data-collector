# frozen_string_literal: true

desc 'enable test coverage'
task :enable_coverage do
  ENV['COVERAGE'] = 'true'
end

desc 'disable test coverage'
task 'disable_coverage' do
  ENV['COVERAGE'] = 'false'
end
