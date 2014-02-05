# coding: utf-8

class UnitTestPlusRunner < TestRunnerComponent
  register!

  @@ERROR_REGEX = /([^\(]+)\((\d+)\): error: Failure in ([^:]+): (.+)$/
  @@SUCCESS_REGEX = /(\d+) tests passed/
  @@FAILURE_REGEX = /(\d+) out of (\d+)/
  @@TIME_REGEX = /Test time: (\d+\.\d\d) (\w+)\.$/

  def initialize params
    explode_params(params)    
  end

  def run_tests
    result = TestResult.new

    lines = IO.popen(@exe.to_winpath, &:readlines).collect { |x| x.from_winpath.delete("\n") }
    errors, summary, time = lines[0..-3], lines[-2], lines[-1]

    if errors.empty?
      summary =~ @@SUCCESS_REGEX

      result.failed = 0
      result.tests = $1.to_i
    else
      summary =~ @@FAILURE_REGEX

      result.failed = $1.to_i
      result.tests = $2.to_i

      errors.each do |err|
        err =~ @@ERROR_REGEX
        result.add_error($1, $2.to_i, $3, $4)
      end
    end

    time =~ @@TIME_REGEX
    result.time = $1

    result
  end

  def self.name
    'Компонент для запуска модульных тестов UnitTest++'
  end

  def self.params_definition
    [
      { :name => 'exe', :description => 'Путь к исполняемому файлу с тестами', :required => true, :hidden => true }
    ]
  end
end


