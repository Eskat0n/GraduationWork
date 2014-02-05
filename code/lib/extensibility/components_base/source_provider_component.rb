require_relative 'component.rb'

class SourceProviderComponent < Component
  def self.base_type
    'SourceProvider'
  end

  def pull
    raise NotImplementedError, "Pull method must be implemented by #{type}"
  end
end

class PullResult
  attr_reader :dirs, :revision

  def initialize dirs, revision
    @dirs, @revision = dirs, revision
  end
end
