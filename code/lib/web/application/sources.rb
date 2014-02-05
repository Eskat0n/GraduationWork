# coding: utf-8

get %r{/source/(\d+)} do |id|
  @source = Source.get(id)
  raise Sinatra::NotFound, 'Источник исходных кодов с таким идентификатором отсутствует в базе' if @source.nil?
  details :details_source, %Q{Источник исходных кодов "#{@source.name}"}
end

get '/source/new' do
  sp = ComponentsRegistry.source_providers
  @types = Catalog.new(sp, :type, :name)
  details :new_source, 'Новый источник исходных кодов'
end

post '/source/new' do
  handle NewSourceFormHandler, params,
    :success => ->(){ redirect to('/sources') },
    :fail => ->(){ details :new_source, 'Новый источник исходных кодов' }
end

get %r{/source/delete/(\d+)} do |id|
  source = Source.get(id)
  raise Sinatra::NotFound, 'Источник исходных кодов с таким идентификатором отсутствует в базе' if source.nil?

  source.destroy!

  redirect to('/sources')
end