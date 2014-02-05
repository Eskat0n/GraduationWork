require_relative 'components_base/source_provider_component.rb'
require_relative 'components_base/target_builder_component.rb'
require_relative 'components_base/test_runner_component.rb'
require_relative 'components_base/report_builder_component.rb'

require_relative 'components_loader.rb'

class ComponentsRegistry
  @@GROUP_TYPES = [:source_providers, :target_builders, :test_runners, :report_builders]

  @@loader = ComponentsLoader.new

  def self.onload &block
    @@loader.onload &block
  end

  def self.onerror &block
    @@loader.onerror &block
  end  

  def self.init path
    @@path = @@GROUP_TYPES.collect { |x| [ x, File.join(File.expand_path(path), x.to_s) ] }.hashize

    self.rebuild!
  end

  def self.rebuild!
    @@components = @@GROUP_TYPES.collect { |x| [ x, [] ] }.hashize

    @@GROUP_TYPES.each do |x|
      @@loader.load_from(@@path[x]) { |c| @@components[x] << c }
    end
  end

  def self.source_providers
    @@components[:source_providers]
  end

  def self.get_source_provider type
    @@components[:source_providers].select { |sp| sp.type.to_s == type }.first
  end

  def self.report_builders
    @@components[:report_builders]
  end

  def self.get_report_builder type
    @@components[:report_builders].select { |rb| rb.type.to_s == type }.first
  end

  def self.[] group_type, type=nil
    return @@components[group_type] if type.nil?
    @@components[group_type].select { |x| x.type.to_s == type }.first
  end

  def self.components
    @@components.values.flatten
  end

  private
  def initialize; end
end
