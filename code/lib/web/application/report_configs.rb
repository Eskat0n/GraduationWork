# coding: utf-8

get %r{/report_config/(\d+)} do |id|
  @report_config = ReportConfiguration.get(id)
  raise Sinatra::NotFound, 'Конфигурация отчетов с таким идентификатором отсутствует в базе' if @report_config.nil?
  details :details_report_config, %Q{Конфигурация отчетов "#{@report_config.name}"}
end

get '/report_config/new' do
  sp = ComponentsRegistry.report_builders
  @types = Catalog.new(sp, :type, :name)
  details :new_report_config, 'Новая конфигурация отчетов'
end

post '/report_config/new' do
  handle NewReportConfigFormHandler, params,
    :success => ->(){ redirect to('/report_configs') },
    :fail => ->(){ details :new_report_config, 'Новая конфигурация отчетов' }
end

get %r{/report_config/delete/(\d+)} do |id|
  report_config = ReportConfiguration.get(id)
  raise Sinatra::NotFound, 'Конфигурация отчетов с таким идентификатором отсутствует в базе' if report_config.nil?
  
  report_config.destroy!

  redirect to('/report_configs')
end