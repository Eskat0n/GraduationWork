require_relative 'component.rb'

class TargetBuilderComponent < Component
  def self.base_type
    'TargetBuilder'
  end

  def build
    raise NotImplementedError, "Build method must be implemented by #{type}"
  end
end

class BuildResult
  attr_accessor :target
  attr_reader :directory, :warnings, :errors, :executable

  def initialize directory, warnings, errors, executable
    @directory, @executable = directory, executable
    @warnings, @errors = warnings, errors
  end

  def success?
    errors.empty?
  end

  def fail?
    not success?
  end
end