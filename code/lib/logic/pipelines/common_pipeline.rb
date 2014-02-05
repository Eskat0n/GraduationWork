require_relative 'pipeline.rb'
require_relative 'source_pull_pipeline.rb'
require_relative 'project_build_pipeline.rb'
require_relative 'project_test_pipeline.rb'
require_relative 'report_create_pipeline.rb'

module SHR
  class CommonPipeline < Pipeline
    def initialize project_id
      super()
      @project = Project.get(project_id)

      raise NoProjectFoundError if @project.nil?
      log_me "Pipeline created for project #{@project.to_text}"
    end

    def act!
      return if @project.nil?      

      begin
        pull_result = SourcePullPipeline.new(@project, @id).act!
        log_me "Pull completed for project #{@project.to_text}"

        unless pull_result.dirs.empty?
          build_result = ProjectBuildPipeline.new(@project, pull_result.dirs, @id).act!
          log_me "Build completed for project #{@project.to_text}"

          executables = build_result.select(&:success?).collect { |x| [ x.target, x.executable ] }.hashize
          test_result = ProjectTestPipeline.new(@project, executables, @id).act!
          log_me "Test completed for project #{@project.to_text}"

          @project.update(:revision => pull_result.revision) unless pull_result.revision.nil?

          report_path = ReportCreatePipeline.new(@project, @id,
            :pull => pull_result,
            :build => build_result,
            :test => test_result
          ).act!

          Report.create(
            :filename => File.basename(report_path),
            :path => report_path,
            :date => Time.now,
            :project => @project,
            :report_config => @project.report_config
          ).save

          Mailer.new.send_report(@project.maintainer_email, @project.title, report_path) if (not @project.maintainer_email.nil?) and SHR::Config.email?
        else
          log_me 'There are no new changes'
        end

        @project.update(:state => :idle)
      rescue PipelineError => e
        log_me e.message
        log_me 'Aborted!'

        @project.update(:state => :idle)

        return
      end

      log_me "Completed!"
    end
  end

  class NoProjectFoundError < RuntimeError
  end
end
