# frozen_string_literal: true

desc 'Deploy lambda function and the associated stacks to AWS'
task :deploy do
  Rake::Task['lambda:create_package'].invoke
  Rake::Task['stack:deploy'].invoke('holdings-data-collector-source-code-stack')
  Rake::Task['stack:deploy'].reenable
  Rake::Task['lambda:upload_package'].invoke
  Rake::Task['stack:deploy'].invoke('holdings-data-s3-bucket-stack')
  Rake::Task['stack:deploy'].reenable
  Rake::Task['stack:deploy'].invoke('holdings-data-collector-stack')
  Rake::Task['lambda:update_function_code'].invoke
end
