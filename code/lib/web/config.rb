# coding: utf-8
# 
# Overall configuration for Sledgehammer

COMPUTER_NAME = ENV['COMPUTERNAME']
INSTANCE_NAME = "Sledgehammer на #{COMPUTER_NAME}"
ENVIRONMENT = SHR::Config.environment

# Sinatra's configuration for Sledgehammer web interface

set :environment, ENVIRONMENT

enable :sessions
disable :run
set :display_warnings, SHR::Config.display_warnings?

set :logging, (SHR::Config.log_web? and SHR::Config.log_console?)
disable :dump_errors if settings.environment == :production

set :root, File.dirname(__FILE__)
set :public, ->() { File.join(root, "static") }
set :views, ->() { File.join(root, "views") }

set :server, :webrick
set :bind, (SHR::Config.publish? ? '0.0.0.0' : 'localhost')
set :port, 9009

require_relative 'config.db.rb'

