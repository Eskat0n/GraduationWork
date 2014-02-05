require_relative 'component.rb'

class ReportBuilderComponent < Component
  def self.base_type
    'ReportBuilder'
  end

  def build_report
    raise NotImplementedError, "Build report method must be implemented by #{type}"
  end

  protected
  def explode_params params
    super(params)

    @united_results = {}

    @results[:build].each do |x|
      @united_results[x.target] = UnitedResultItem.new unless @united_results.key? x.target
      @united_results[x.target].build = x;
    end

    @results[:test].each do |x|
      @united_results[x.target] = UnitedResultItem.new unless @united_results.key? x.target
      @united_results[x.target].test = x;
    end
  end
end

class UnitedResultItem
  attr_reader :build, :test

  def build= value
    raise 'Build result is already set' unless @build.nil?
    @build = value
  end

  def test= value
    raise 'Build result is already set' unless @test.nil?
    @test = value
  end
end
