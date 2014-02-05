require_relative 'pipeline.rb'

module SHR
  class ReportCreatePipeline < Pipeline
    def initialize project, parent_id, results={}
      super(parent_id)
      @project, @results = project, results
    end

    def act!
      @project.update(:state => :reporting)

      report_config = @project.report_config
      raise PipelineError, "No report configuration found for project #{@project.to_text}" if report_config.nil?
      
      log_me "Creating component of type #{report_config.type} for report configuration #{report_config.to_text}"

      rb = ComponentsRegistry.get_report_builder(report_config.type)
      raise PipelineError, "Component of type #{report_config.type} not found" if rb.nil?

      merged_params = report_config.params.merge({'results' => @results, 'project' => @project.to_dto})
      begin        
        rb = rb.new(merged_params)
        log_me "Component of type #{report_config.type} created for project #{@project.to_text}"
      rescue
        raise PipelineError, "Error creating component of type #{report_config.type}"
      end

      rb.build_report
    end
  end
end
