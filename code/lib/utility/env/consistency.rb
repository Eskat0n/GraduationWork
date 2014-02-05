# coding: utf-8

module SHR
  class Consistency
    @@errors = []

    def self.consistent?
      self.fatals.empty?
    end

    def self.warnings?
      not self.warnings.empty?
    end

    def self.check
      if Dir.exists?('data')
        fatal('Файл базы данных SQLite не существует') unless File.exists?('data/database.sqlite')
      else
        fatal('Директория для хранения данных системы не существует')
      end

      fatal('Директория для хранения временных файлов не существует') unless Dir.exists?(Config.temp_dir)
      fatal('Директория для хранения логов не существует') if (Config.log_web? or Config.log_system?) and (not Dir.exists?(Config.log_path))
    end

    def self.warning message, class_name=nil
      @@errors << {
        :type => :warning,
        :message => message,
        :class_name => class_name
      }
    end

    def self.fatal message, class_name=nil
      @@errors << {
        :type => :fatal,
        :message => message,
        :class_name => class_name
      }
    end

    def self.warnings
      @@errors.select { |x| x[:type] == :warning }
    end    

    def self.errors
      @@errors
    end

    def self.fatals
      @@errors.select { |x| x[:type] == :fatal }
    end

    def self.persist_errors filename
      File.open(filename, 'w') do |fio|
        now = Time.now.strftime('%d.%m.%y %H:%M:%S')
        fio.puts "Создано #{now}"
        @@errors.each do |e|
          fio.puts "- [#{e[:type].upcase}] #{e[:message]} / Класс ошибки: #{e[:class_name] or 'отсутствует'}"
        end
      end unless @@errors.empty?
    end

    private
    def initialize; end
  end
end