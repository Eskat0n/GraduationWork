# coding: utf-8

require 'rubygems'

# change working directory to directory of main.rb file
Dir.chdir(File.expand_path(File.dirname(__FILE__)))

INSTALL = true
ENVIRONMENT = :production

# load installer classes
require_relative 'installer/workflow/step.rb'
require_relative 'installer/workflow/workflow.rb'

# load step classes
require_relative 'installer/load_sqlite_libraries.rb'
require_relative 'installer/gems_installation.rb'
require_relative 'installer/database_creation.rb'
require_relative 'installer/desktop_bat_script_creation.rb'

installer = Installer::Workflow.new(
  Installer::LoadSQLiteLibraries.new,
  Installer::GemsInstallation.new,
  Installer::DatabaseCreation.new,
  Installer::DesktopBatScriptCreation.new
)

puts 'Starting Sledgehammer installation'
installer.go!
puts 'Sledgehammer installation complete'
puts 'Please do not forget to make nessesary changes to config.yml'