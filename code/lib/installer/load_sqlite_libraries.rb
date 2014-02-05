require 'fileutils'

module Installer
  class LoadSQLiteLibraries < Step
    @@DEF = 'sqlite3.def'
    @@DLL = 'sqlite3.dll'

    def initialize      
    end

    def act!
      @ruby_directory = ENV['Path'].split(';')
        .select { |x| x.include?('Ruby') and x.include?('bin') }
        .select { |x| File.exist?(File.join(x, 'ruby.exe')) }.first

      raise "No ruby directory found. Could not verify presence or install SQLite3 library" if @ruby_directory.nil?

      if File.exist?(File.join(@ruby_directory, @@DEF)) and File.exist?(File.join(@ruby_directory, @@DLL))
        puts "SQLite3 dll found in your Ruby bin directory (#{@ruby_directory})"
        return
      end

      Dir.glob('installer/.sqlite3_redist/*').each { |x| FileUtils.cp(x, @ruby_directory) }
      puts "SQLite3 libraries moved to your Ruby bin directory (#{@ruby_directory})"
    end
  end
end
