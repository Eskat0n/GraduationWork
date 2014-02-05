require_relative 'pipeline.rb'

module SHR
  class ProjectTestPipeline < Pipeline
    def initialize project, executables, parent_id
      super(parent_id)
      @project, @executables = project, executables
    end

    def act!
      @project.update(:state => :testing)

      test_config = @project.test_config
      raise PipelineError, "No test configuration found for project #{@project.to_text}" if test_config.nil?
      log_me "Creating component of type #{test_config.type} for source #{test_config.to_text}"

      tr_type = ComponentsRegistry[:test_runners, test_config.type]
      raise PipelineError, "Component of type #{test_config.type} not found" if tr_type.nil?

      @executables.collect do |target, executable|
        begin
          @tr = tr_type.new(test_config.params.merge('exe' => executable))
          log_me "Component of type #{test_config.type} created for project #{@project.to_text}"
        rescue
          raise PipelineError, "Error creating component of type #{test_config.type}"
        end

        log_me "Running tests for executable #{executable}"
        
        result = @tr.run_tests
        result.target = target
        result
      end
    end
  end
end
