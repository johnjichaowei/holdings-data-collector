# frozen_string_literal: true

namespace :stack do # rubocop:disable Metrics/BlockLength
  require 'active_support'
  require 'active_support/core_ext/string/inflections.rb'
  require 'aws-sdk-cloudformation'
  require 'json'

  class DeployStackError < StandardError; end

  CFN_SUCCESS_STATES = %w[
    CREATE_COMPLETE
    UPDATE_COMPLETE
  ].freeze
  CFN_FAILURE_STATES = %w[
    CREATE_FAILED
    ROLLBACK_FAILED
    ROLLBACK_COMPLETE
    UPDATE_ROLLBACK_FAILED
    UPDATE_ROLLBACK_COMPLETE
    DELETE_FAILED
    DELETE_COMPLETE
  ].freeze
  STACK_MONITOR_INTERNAL = 3 # seconds

  load_template = lambda do |file_name|
    File.open(file_name, &:read)
  end

  load_params = lambda do |file_name|
    File.open(file_name) do |f|
      JSON.parse(f.read).map { |param_hash| param_hash.transform_keys!(&:underscore) }
    end
  end

  stack_payload = lambda do |stack_name|
    {
      template_body: load_template.call("cloudformation/#{stack_name}/template.yml"),
      parameters: load_params.call("cloudformation/#{stack_name}/params.json"),
      capabilities: ['CAPABILITY_IAM']
    }
  end

  render_stack_event = lambda do |e|
    time = e.timestamp.iso8601
    puts "#{time} #{e.resource_type}[#{e.logical_resource_id}] #{e.resource_status} #{e.resource_status_reason}"
  end

  get_events_to_render = lambda do |events, last_stack_event|
    last_stack_event.nil? ? events : events.select { |e| e.timestamp > last_stack_event.timestamp }
  end

  render_stack_events = lambda do |events, last_stack_event|
    events_to_render = get_events_to_render.call(events, last_stack_event).sort_by(&:timestamp)
    events_to_render.each { |e| render_stack_event.call(e) }
    events_to_render.any? ? events_to_render.last : last_stack_event
  end

  monitor_statck_deployment = lambda do |stack, last_stack_event|
    last_stack_event = render_stack_events.call(stack.events, last_stack_event)
    loop do
      if CFN_SUCCESS_STATES.include?(stack.stack_status)
        puts "Deploy stack #{stack.name} finished successfully"
        break
      elsif CFN_FAILURE_STATES.include?(stack.stack_status)
        error = "Failed to deploy stack #{stack.name}: #{stack.stack_status} - #{stack.stack_status_reason}"
        raise DeployStackError, error
      else
        sleep(STACK_MONITOR_INTERNAL)
        stack.reload
        last_stack_event = render_stack_events.call(stack.events, last_stack_event)
      end
    end
  end

  deploy_stack = lambda do |cfn, stack_name|
    stack = cfn.stack(stack_name)
    payload = stack_payload.call(stack_name)
    last_stack_event = nil
    begin
      if stack.exists?
        puts "Update stack #{stack_name}"
        last_stack_event = stack.events.max_by(&:timestamp)
        stack.update(payload)
      else
        puts "Create stack #{stack_name}"
        stack.create(payload)
      end

      monitor_statck_deployment.call(stack, last_stack_event)
    rescue Aws::CloudFormation::Errors::ValidationError => e
      if /No updates are to be performed./.match?(e.message)
        puts e.message
      else
        puts "Deploy stack #{stack.name} failed due to #{e.message}"
        raise
      end
    end
  end

  desc 'Deploy cloudformation stack'
  task :deploy, [:stack_name] do |_t, args|
    puts "Deploy stack #{args.stack_name}"
    cfn = Aws::CloudFormation::Resource.new
    deploy_stack.call(cfn, args.stack_name)
    puts 'Deploy stack finished'
  end
end
