ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV'].to_sym

$LOAD_PATH << __dir__

require 'jinaki/helper'
require 'jinaki/model'
require 'jinaki/controller'
require 'jinaki/route'
require 'jinaki/app'

module Jinaki
end
