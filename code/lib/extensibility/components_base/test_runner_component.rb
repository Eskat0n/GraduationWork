require_relative 'component.rb'

class TestRunnerComponent < Component
  def self.base_type
    'TestRunner'
  end

  def run_tests
    raise NotImplementedError, "Run tests method must be implemented by #{type}"
  end
end

class TestResult
  attr_accessor :failed, :tests, :time, :target
  attr_reader :errors

  def initialize
    @errors = []
  end

  def add_error file, line, name, operator
    @errors << FailedTest.new(file, line, name, operator)
  end

  def success?
    @errors.empty?
  end
end

class FailedTest
  attr_reader :file, :line, :name, :operator

  def initialize file, line, name, operator
    @file, @line, @name, @operator = file, line, name, operator
  end
end