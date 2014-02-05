module Installer
  class DatabaseCreation < Step
    @@DATABASE_FILENAME = File.join(Dir.pwd, 'data', 'database.sqlite')

    def initialize
    end

    def act!
      File.open(@@DATABASE_FILENAME, 'w').close
      puts 'SQLite database successfully created'

      require_relative '../web/migration.rb'
      puts 'Database tables structure initialized'
    end
  end
end
