# coding: utf-8

require_relative 'project_form_handler_base.rb'

class EditProjectFormHandler < ProjectFormHandlerBase
  def validate form
    vresult = super(form)

    project_id = form[:project][:id].to_i
    if project_id.nil? or Project.get(project_id).nil?
      vresult.add_error 'form', 'Несуществующий проект'
    end

    vresult
  end

  def handle form  
    project_form = form[:project]

    project = Project.get(form[:project][:id].to_i)
    project.update(
      :title => project_form[:title],
      :description => project_form[:description],
      :maintainer_email => project_form[:email],
      :interval => project_form[:interval].to_i,
      :source => Source.get(project_form[:source].to_i),
      :build_config => BuildConfiguration.get(project_form[:build_config].to_i),
      :test_config => TestConfiguration.get(project_form[:test_config].to_i),
      :report_config => ReportConfiguration.get(project_form[:report_config].to_i)
    )
  end
end
