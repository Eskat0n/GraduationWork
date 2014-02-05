# coding: utf-8

if __FILE__ == $0 and (not defined? INSTALL)
  ENVIRONMENT = :development

  require 'data_mapper'
  require_relative 'config.db.rb'
  require_relative 'domain/load_all.rb'

  DataMapper.auto_migrate!

  exit
end

if ENVIRONMENT == :production
  require 'data_mapper'
  require_relative 'config.db.rb'
  require_relative 'domain/load_all.rb'

  Dir.chdir('data') { DataMapper.auto_migrate! }
end