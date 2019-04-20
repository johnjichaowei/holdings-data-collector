namespace :lambda do
  desc 'Upload lambda package to S3 bucket'
  task :upload_package, [:package_file, :bucket_name, :object_key] do |t, args|
    require 'aws-sdk-s3'

    args.with_defaults(
      package_file: 'dist/lambda.zip',
      bucket_name: 'holdings-data-collector-lambda-source-code',
      object_key: 'holdings-data-collector-lambda.zip'
    )

    puts "Upload lambda package #{args.package_file} to S3 bucket #{args.bucket_name} as #{args.object_key}..."
    s3 = Aws::S3::Resource.new
    obj = s3.bucket(args.bucket_name).object(args.object_key)
    obj.upload_file(args.package_file)
    puts 'Upload lambda package finished'
  end
end
