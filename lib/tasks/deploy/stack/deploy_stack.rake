# frozen_string_literal: true

namespace :stack do
  require 'active_support'
  require 'active_support/core_ext/string/inflections.rb'
  require 'aws-sdk-cloudformation'
  require 'json'

  class DeployStackError < StandardError; end

  load_template = -> (file_name) do
    open(file_name) { |f| f.read }
  end

  load_params = -> (file_name) do
    open(file_name) do |f|
      JSON.parse(f.read).map { |param_hash| param_hash.transform_keys!(&:underscore) }
    end
  end

  stack_payload = -> (stack_name) do
    {
      template_body: load_template.call("cloudformation/#{stack_name}/template.yml"),
      parameters: load_params.call("cloudformation/#{stack_name}/params.json"),
      capabilities: ['CAPABILITY_IAM']
    }
  end

  update_stack = -> (stack, payload) do
    begin
      stack.update(payload)
    rescue Aws::CloudFormation::Errors::ValidationError => e
      if /No updates are to be performed./ =~ e.message
        puts e.message
      else
        puts "Update stack #{stack.name} failed due to #{e.message}"
        raise
      end
    end
  end

  deploy_stack = -> (cfn, stack_name) do
    stack = cfn.stack(stack_name)
    payload = stack_payload.call(stack_name)
    if stack.exists?
      puts "Update stack #{stack_name}"
      update_stack.call(stack, payload)
    else
      puts "Create stack #{stack_name}"
      stack.create(payload)
    end
  end

  task :deploy_stack, [:stack_name] do |t, args|
    args.with_defaults(
      stack_name: 'holdings-data-collector-source-code-stack'
    )

    puts "Deploy stack #{args.stack_name}"
    cfn = Aws::CloudFormation::Resource.new
    deploy_stack.call(cfn, args.stack_name)
    puts "Deploy stack finished"
  end
end
