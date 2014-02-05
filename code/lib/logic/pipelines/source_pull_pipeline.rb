require_relative 'pipeline.rb'

module SHR
  class SourcePullPipeline < Pipeline
    def initialize project, parent_id
      super(parent_id)
      @project = project
    end

    def act!
      @project.update(:state => :pulling)

      source = @project.source
      raise PipelineError, "No source found for project #{@project.to_text}" if source.nil?
      
      log_me "Creating component of type #{source.type} for source #{source.to_text}"

      sp = ComponentsRegistry.get_source_provider(source.type)
      raise PipelineError, "Component of type #{source.type} not found" if sp.nil?

      begin
        sp = sp.new(source.params)
        log_me "Component of type #{source.type} created for project #{@project.to_text}"
      rescue RuntimeError => err
        raise PipelineError, "Error creating component of type #{source.type}: #{err}"
      end

      sp.pull(@project.revision)
    end
  end
end
