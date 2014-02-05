# coding: utf-8

get %r{/build_config/(\d+)} do |id|
  @build_config = BuildConfiguration.get(id)
  raise Sinatra::NotFound, 'Конфигурация сборки с таким идентификатором отсутствует в базе' if @build_config.nil?
  details :details_build_config, %Q{Конфигурация сборки "#{@build_config.name}"}
end

get '/build_config/new' do
  @types = Catalog.new(ComponentsRegistry[:target_builders], :type, :name)
  details :new_build_config, 'Новая конфигурация сборки'
end

post '/build_config/new' do
  handle NewBuildConfigFormHandler, params,
    :success => ->(){ redirect to('/build_configs') },
    :fail => ->(){ details :new_build_config, 'Новая конфигурация сборки' }
end

get %r{/build_config/delete/(\d+)} do |id|
  build_config = BuildConfiguration.get(id)
  raise Sinatra::NotFound, 'Конфигурация сборки с таким идентификатором отсутствует в базе' if build_config.nil?

  build_config.destroy!

  redirect to('/build_configs')
end