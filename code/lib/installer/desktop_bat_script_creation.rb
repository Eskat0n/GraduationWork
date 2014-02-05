module Installer
  class DesktopBatScriptCreation < Step
    def initialize
    end

    def condition
      ask 'Do you want to place bat script to start Sledgehammer on your desktop?'
    end

    def act!
      @desktop_path = File.join(ENV['HOME'], 'Desktop')

      raise "Could not locate desktop by path: #{@desktop_path}" unless File.exist?(@desktop_path)

      File.open(File.join(@desktop_path, 'Start Sledgehammer.bat'), 'w') do |fio|
        fio.puts %Q{ruby.exe "#{Dir.pwd}/main.rb"}
      end
      puts 'Bat script successfully created'
    end
  end
end
