# coding: utf-8

require_relative 'bootstrap.rb'

require_relative 'application/security.rb'
require_relative 'application/projects.rb'
require_relative 'application/sources.rb'
require_relative 'application/build_configs.rb'
require_relative 'application/test_configs.rb'
require_relative 'application/report_configs.rb'
require_relative 'application/components.rb'
require_relative 'application/system.rb'
require_relative 'application/prehandlers.rb'

get '/' do
  redirect to('/projects')
end

get '/projects' do
  @projects = Project.all
  overview :overview_projects, 'Список проектов'
end

get '/sources' do
  @sources = Source.all
  overview :overview_sources, 'Список источников исходных кодов'
end

get '/build_configs' do
  @build_configs = BuildConfiguration.all
  overview :overview_build_configs, 'Список конфигураций сборки'
end

get '/test_configs' do
  @test_configs = TestConfiguration.all
  overview :overview_test_configs, 'Список конфигураций запуска тестов'
end

get '/report_configs' do
  @report_configs = ReportConfiguration.all
  overview :overview_report_configs, 'Список конфигураций отчетов'
end
