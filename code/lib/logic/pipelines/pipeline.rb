require_relative 'pipeline_errors.rb'

module SHR
  class Pipeline
    @@max_id = 0

    attr_reader :id

    def initialize id=nil
      @id = id.nil? ? get_id : id
    end

    def act!
      raise NotImplementedError, 'Class derived from Pipeline must implement act! method'
    end

    protected
    def log_me message
      log "Pipeline ##{@id}: #{message}"
    end

    protected
    def get_id
      @@max_id += 1
    end
  end
end
