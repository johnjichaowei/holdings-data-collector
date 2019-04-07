# frozen_string_literal: true

require 'logger'

LOGGER = ENV['APP_ENV'] == 'test' ? Logger.new('/dev/null') : Logger.new(STDOUT)
