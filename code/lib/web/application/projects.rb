# coding: utf-8

require 'uri'

get %r{/project/(\d+)} do |id|
  @project = Project.get(id)
  raise Sinatra::NotFound, 'Проект с таким идентификатором отсутствует в базе' if @project.nil?
  
  details :details_project, %Q{Проект "#{@project.title}"}
end

get '/project/new' do
  @sources = EntityCatalog.new(Source)
  @build_configs = EntityCatalog.new(BuildConfiguration)
  @test_configs = EntityCatalog.new(TestConfiguration)
  @report_configs = EntityCatalog.new(ReportConfiguration)

  details :new_project, 'Новый проект'
end

post '/project/new' do
  @sources = EntityCatalog.new(Source)
  @build_configs = EntityCatalog.new(BuildConfiguration)
  @test_configs = EntityCatalog.new(TestConfiguration)
  @report_configs = EntityCatalog.new(ReportConfiguration)

  handle NewProjectFormHandler, params,
    :success => ->(){ SHR::Scheduler.default.spawn_task(@handle_result); redirect to('/projects') },
    :fail => ->(){ details :new_project, 'Новый проект' }
end

get %r{/project/edit/(\d+)} do |id|
  @project = Project.get(id)
  raise Sinatra::NotFound, 'Проект с таким идентификатором отсутствует в базе' if @project.nil?

  source, build_config, test_config, report_config = @project.source, @project.build_config, @project.test_config, @project.report_config
  @sources = Catalog.new(Source.all, :id, :name, source.nil? ? nil : source.id).prepend('0', '---', source.nil?)
  @build_configs = Catalog.new(BuildConfiguration.all, :id, :name, build_config.nil? ? nil : build_config.id).prepend('0', '---', build_config.nil?)
  @test_configs = Catalog.new(TestConfiguration.all, :id, :name, test_config.nil? ? nil : test_config.id).prepend('0', '---', test_config.nil?)
  @report_configs = Catalog.new(ReportConfiguration.all, :id, :name, report_config.nil? ? nil : report_config.id).prepend('0', '---', report_config.nil?)

  details :edit_project, %Q{Редактирование проекта "#{@project.title}"}
end

post '/project/edit' do
  handle EditProjectFormHandler, params,
    :success => ->(){ redirect to('/projects') },
    :fail => ->(){ redirect "/project/edit/#{params[:project][:id]}" }
end

get %r{/project/delete/(\d+)} do |id|
  project = Project.get(id)
  raise Sinatra::NotFound, 'Проект, который вы собирались удалить, отсутствует в базе' if project.nil?

  project.destroy

  redirect to('/projects')
end

get %r{/project/report/(\d+)} do |id|
  @report = Report.get(id)
  raise Sinatra::NotFound, 'Отчет с таким идентификатором отсутствует в базе' if @report.nil?

  if SHR::Config.viewable_reports.include? File.extname(@report.path)
    details :details_report, 'Просмотр отчета', :backlink_href => "/project/#{@report.project.id}", :backlink_text => 'На детали проекта'
  else
    file_attachment @report.path
  end
end

get %r{/ajax/projects/state/(\d+)} do |id|
  Project.get(id).state_description
end