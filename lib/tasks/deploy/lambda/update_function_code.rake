namespace :lambda do
  desc 'Update lambda function code'
  task :update_function_code, [:function_name, :bucket_name, :object_key] do |t, args|
    require 'aws-sdk-lambda'

    args.with_defaults(
      function_name: 'holdings-data-collector-lambda',
      bucket_name: 'holdings-data-collector-lambda-source-code',
      object_key: 'holdings-data-collector-lambda.zip'
    )

    puts "Update function code for #{args.function_name} with #{args.object_key} in S3 bucket #{args.bucket_name}..."
    client = Aws::Lambda::Client.new
    client.update_function_code(
      function_name: args.function_name,
      s3_bucket: args.bucket_name,
      s3_key: args.object_key
    )
    puts 'Update function code finished'
  end
end
