require 'yaml'

module SHR
  class ConfigNotInitializedError < RuntimeError
  end

  class Config
    @@config = nil

    def self.init filename='config.yml'
      @@config, @@filename = YAML.load_file(filename), filename
    end

    def self.environment
      ready?
      @@config['environment'].to_sym
    end

    def self.web?
      ready?
      @@config['web']['enable'] or false
    end

    def self.user
      ready?
      @@config['security']['user']
    end

    def self.publish?
      ready?
      @@config['web']['publish'] or false
    end

    def self.email?
      ready?
      @@config['email'] or false
    end

    def self.email_from
      ready?
      @@config['email']['from']
    end

    def self.smtp
      ready?
      @@config['email']['smtp']
    end

    def self.temp_dir
      ready?
      @@config['tempdir'] or 'temp'
    end

    def self.log_web?
      ready?
      @@config['logging']['web'] or false
    end

    def self.log_system?
      ready?
      @@config['logging']['system'] or false
    end

    def self.log_path
      ready?
      @@config['logging']['path'] or 'logs'
    end

    def self.log_filename
      ready?
      @@config['logging']['filename'] or 'log_%crtime'
    end

    def self.log_console?
      ready?
      @@config['logging']['console'] or false
    end

    def self.developer_email
      ready?
      @@config['developer_email']
    end

    def self.admin_email
      ready?
      @@config['admin_email']
    end

    def self.display_warnings?
      ready?
      @@config['web']['display_warnings'] or false
    end

    def self.viewable_reports
      ready?
      @@config['viewable_reports'] or []
    end

    def self.local_codepage
      ready?
      @@config['local_codepage']
    end

    def self.component_params type
      ready?
      
      components = @@config['components']
      return {} if components.nil?

      params = components[type]
      params.nil? ? {} : params
    end

    private
    def self.ready?
      raise ConfigNotInitializedError if @@config.nil?
    end

    private
    def initialize; end
  end
end