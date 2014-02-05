require 'uuid'

class Component
  @@TEMP_DIR = File.expand_path(SHR::Config.temp_dir)

  def self.base_type
    raise NotImplementedError, 'Implementation of Component must have base_type set'
  end
  
  def self.name
    raise NotImplementedError, 'Implementation of Component must have name set'
  end

  def self.full_name
    "#{self.name} [#{self.type}]"
  end

  def self.description
    nil
  end

  def self.type
    self
  end

  def self.params_definition
    []
  end
  
  protected
  def self.register!
    ComponentsLoader << self
  end

  protected
  def self.get_mydir filepath
    File.expand_path(File.dirname(filepath))
  end

  protected
  def explode_params params
    merged_params = SHR::Config.component_params(self.class.to_s).merge(params)
    
    self.class.params_definition.each do |pd|
      name = pd[:name]
      value = merged_params[name]

      # correction for hidden parameters - value mustn't be overridden by config
      value = params[name] if pd[:hidden] === true

      if pd[:required] === true
        raise %Q{No value specified for required parameter "#{name}"} if value.nil?
        instance_variable_set(:"@#{name}", value)
      else
        value = value.nil? ? pd[:default] : value
        instance_variable_set(:"@opt_#{name}", value)
      end
    end
  end

  protected
  def get_temp
    tempdir = File.join(@@TEMP_DIR, UUID.generate(:compact))
    Dir.mkdir(tempdir)
    tempdir
  end
end
