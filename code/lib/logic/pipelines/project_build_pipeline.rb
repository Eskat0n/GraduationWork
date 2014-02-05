require_relative 'pipeline.rb'

module SHR
  class ProjectBuildPipeline < Pipeline
    def initialize project, directories, parent_id
      super(parent_id)
      @project, @directories = project, directories
    end

    def act!
      @project.update(:state => :building)

      build_config = @project.build_config
      raise PipelineError, "No build configuration found for project #{@project.to_text}" if build_config.nil?
      log_me "Creating component of type #{build_config.type} for source #{build_config.to_text}"

      tb_type = ComponentsRegistry[:target_builders, build_config.type]
      raise PipelineError, "Component of type #{build_config.type} not found" if tb_type.nil?

      @directories.collect do |target, path|
        begin
          @tb = tb_type.new(build_config.params.merge('dir' => path))
          log_me "Component of type #{build_config.type} created for project #{@project.to_text}"
        rescue RuntimeError => err
          raise PipelineError, "Error creating component of type #{build_config.type}: #{err}"
        end
        
        log_me "Building target #{target} in directory #{path}"

        result = @tb.build
        result.target = target
        result
      end
    end
  end
end

