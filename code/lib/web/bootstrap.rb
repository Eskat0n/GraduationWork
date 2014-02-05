require 'data_mapper'
require 'haml'
require 'sinatra'
require 'json'

# load config
require_relative 'config.rb'

# load all from domain
require_relative 'domain/load_all.rb'

# load errors
require_relative 'errors/form_handler_error.rb'
require_relative 'errors/error_handlers.rb'

# load validation classes
require_relative 'validation/validation_result.rb'

# load form handlers
require_relative 'form_handlers/new_project_form_handler.rb'
require_relative 'form_handlers/edit_project_form_handler.rb'
require_relative 'form_handlers/new_source_form_handler.rb'
require_relative 'form_handlers/new_build_config_form_handler.rb'
require_relative 'form_handlers/new_test_config_form_handler.rb'
require_relative 'form_handlers/new_report_config_form_handler.rb'

# load metaobjects
require_relative 'metaobjects/catalog.rb'
require_relative 'metaobjects/entity_catalog.rb'

# load filters
require_relative 'filters/filters.rb'

# load helpers
require_relative 'helpers/validation_messages.rb'
require_relative 'helpers/form_handling.rb'
require_relative 'helpers/views.rb'
require_relative 'helpers/layouts.rb'
require_relative 'helpers/route_results.rb'
