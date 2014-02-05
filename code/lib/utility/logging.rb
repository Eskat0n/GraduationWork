# coding: utf-8

module SHR
  class Logger
    @@PLACEHOLDERS = {
      :starttime => ->(logger){ logger.start_time.to_filename_time },
      :crtime => ->(logger){ Time.now.to_filename_time },
    }        

    attr_reader :start_time

    def initialize
      @start_time = Time.now
      @logpath, @filename = Config.log_path, nil

      Dir.create_if_none(@logpath)
      
      @system, @console = Config.log_system?, Config.log_console?
      if @system
        @filename = get_filename(@logpath, 'log')
        @file_io = File.open(@filename, 'w')
        @file_io.autoclose = true
      end
    end

    def << message      
      timed_message = "[#{Time.now.to_longtime}] #{message}"

      puts(timed_message) if @console
      if @system
        @file_io.puts(timed_message)
        @file_io.flush
      end
    end

    def current
      @filename
    end

    private
    def get_filename path, ext
      filename = Config.log_filename
      @@PLACEHOLDERS.each { |k, v| filename.gsub! Regexp.new("%#{k.to_s}"), v.(self) }

      filename, i = File.join(path, "#{filename}.#{ext}"), 1
      while File.exists?(filename) do; filename.gsub!(Regexp.new("\\[\\d+\\].#{ext.gsub(/\./, '\\.')}$"), (i+=1).to_s); end
      filename
    end
  end
end

LOG_BUFFER = []

def log_delayed message
  LOG_BUFFER << message
end

def log message
  if (defined? LOGGER) and (not LOGGER.nil?)
    LOG_BUFFER.each { |x| LOGGER << x }.clear
    LOGGER << message
  end
end