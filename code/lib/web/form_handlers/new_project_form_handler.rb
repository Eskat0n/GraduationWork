require_relative 'project_form_handler_base.rb'

class NewProjectFormHandler < ProjectFormHandlerBase
  def handle form
    project_form = form[:project]

    project = Project.create({
      :title => project_form[:title],
      :description => project_form[:description],
      :maintainer_email => project_form[:email],
      :interval => project_form[:interval].to_i,
      :source => Source.get(project_form[:source].to_i),
      :build_config => BuildConfiguration.get(project_form[:build_config].to_i),
      :test_config => TestConfiguration.get(project_form[:test_config].to_i),
      :report_config => ReportConfiguration.get(project_form[:report_config].to_i)
    })
    project.save
    project
  end
end
