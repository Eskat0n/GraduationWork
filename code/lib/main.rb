# coding: utf-8

require 'rubygems'

# change working directory to directory of main.rb file
Dir.chdir(File.expand_path(File.dirname(__FILE__)))

# load utility helpers
require_relative 'utility/extensions.rb'
require_relative 'utility/env/config.rb'
require_relative 'utility/env/consistency.rb'
require_relative 'utility/load_helper.rb'
require_relative 'utility/logging.rb'
require_relative 'utility/filesystem.rb'
require_relative 'utility/time_span.rb'
require_relative 'utility/winfixes.rb'

# load shared code
load_all_from 'utility/shared'

# initialize config
log_delayed 'Initializing configuration...'
SHR::Config.init
log_delayed 'Configuration initialized successfully'

# create logger
LOGGER = SHR::Logger.new

# check system for consistency
log 'Checking system for consistency'
SHR::Consistency.check
if SHR::Consistency.consistent?
  log 'System in consistent state'
  log 'There are also some warnings. Check system_errors.txt file for more details' if SHR::Consistency.warnings?
else
  SHR::Consistency.persist_errors('system_errors.txt')
  log 'There are errors in system state. Check web interface or system_errors.txt file for more details'  
end

# temp directory cleanup
Dir.cleanup SHR::Config.temp_dir
log 'Temp directory cleaned'

# load extensibility classes
require_relative 'extensibility/components_registry.rb'

# initialize components registry
log 'Loading components...'
ComponentsRegistry.onload { |type, base_type| log "Component #{type} of type #{base_type} loaded" }
ComponentsRegistry.onerror do |message|
  SHR::Consistency.warning(message, 'ComponentLoadingError')
  log "WARNING: #{message}"
end
ComponentsRegistry.init 'components'
log "All components (#{ComponentsRegistry.components.size}) loaded successfully"

# load logic
require_relative 'logic/mailer.rb'
require_relative 'logic/pipelines/common_pipeline.rb'
require_relative 'logic/scheduler.rb'

# load web interface
log 'Loading web interface...'
require_relative 'web/application.rb'

if SHR::Config.web?
  log 'Spawning web application thread...'
  Thread.start { Sinatra::Application.run! }
end

Thread.abort_on_exception = true

log 'Starting scheduling service...'
if SHR::Consistency.consistent?
  sheduler = SHR::Scheduler.new
  sheduler.start
  log 'Scheduling service successfully started'
  log 'All green. System started'
else
  log "Couldn't start scheduling service due to unconsistent system state"
end

sleep