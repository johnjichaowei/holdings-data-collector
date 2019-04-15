# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'envied'

ENVied.require
$LOAD_PATH.unshift(File.expand_path('../app', __dir__))
