# coding: utf-8
#
# Configuration for Sledgehammer database access level

DataMapper::Logger.new($stdout, :debug) unless ENVIRONMENT == :production

Dir.chdir('data') do
  DataMapper.setup(:default, 'sqlite:///database.sqlite')
end if Dir.exists?('data')

DataMapper::Property::String.length(255)