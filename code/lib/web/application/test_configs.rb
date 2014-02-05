# coding: utf-8

get %r{/test_config/(\d+)} do |id|
  @test_config = TestConfiguration.get(id)
  raise Sinatra::NotFound, 'Конфигурация запуска тестов с таким идентификатором отсутствует в базе' if @test_config.nil?
  details :details_test_config, %Q{Конфигурация запуска тестов "#{@test_config.name}"}
end

get '/test_config/new' do
  @types = Catalog.new(ComponentsRegistry[:test_runners], :type, :name)
  details :new_test_config, 'Новая конфигурация запуска тестов'
end

post '/test_config/new' do
  handle NewTestConfigFormHandler, params,
    :success => ->(){ redirect to('/test_configs') },
    :fail => ->(){ details :new_test_config, 'Новая конфигурация запуска тестов' }
end

get %r{/test_config/delete/(\d+)} do |id|
  test_config = TestConfiguration.get(id)
  raise Sinatra::NotFound, 'Конфигурация запуска тестов с таким идентификатором отсутствует в базе' if test_config.nil?

  test_config.destroy!

  redirect to('/test_configs')
end