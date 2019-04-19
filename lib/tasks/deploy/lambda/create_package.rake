# frozen_string_literal: true

namespace :lambda do
  task :clean do
    rm_rf 'dist'
    rm_rf 'vendor'
  end

  task :create_dist_dir do
    mkdir_p 'dist'
    mkdir_p 'vendor/bundle'
  end

  task :install_libraries do
    puts 'Install depending libraries...'
    system("bundle install --path vendor/bundle --without='develoopment test deployment'")
  end

  desc 'Create package for lambda function'
  task create_package: %w[clean create_dist_dir install_libraries] do
    require 'zip'

    puts 'Create lambda pacakge file...'
    zipfile_name = 'dist/lambda.zip'
    source_files = Rake::FileList.new('app/**/*.rb', 'system/**/*.rb')
    libraries_files = Rake::FileList.new('vendor/**/*')

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      source_files.each { |source_file| zipfile.add(source_file, source_file) }
      libraries_files.each { |library_file| zipfile.add(library_file, library_file) }
    end
  end
end
