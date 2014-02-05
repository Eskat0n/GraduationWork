module Installer
  class GemsInstallation < Step
    @@GEMS = %w{nokogiri sinatra data_mapper dm-sqlite-adapter json haml pony uuid}

    def initialize 
    end

    def act!
      puts 'Installing required gems'

      IO.popen("gem.bat install #{@@GEMS.join(' ')}") do |io|
        io.each_line do |line|
          puts line
        end
      end
      puts 'Gems installed'
    end
  end
end
