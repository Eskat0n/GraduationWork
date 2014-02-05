# coding: utf-8

get '/components' do
  @source_providers = ComponentsRegistry[:source_providers]
  @target_builders = ComponentsRegistry[:target_builders]
  @test_runners = ComponentsRegistry[:test_runners]
  @report_builders = ComponentsRegistry[:report_builders]

  overview :overview_components, 'Список компонентов',
    :additional_tools => haml("%a.action.softlink(href='/components/rebuild') Пересобрать реестр компонентов")
end

get '/components/rebuild' do
  puts 'Reloading components...'
  ComponentsRegistry.rebuild!
  puts "All components (#{ComponentsRegistry.components.size}) reloaded successfully"

  redirect to('/components')
end

get '/ajax/components/parameters/:type' do |type|
  params_definition = [
    ComponentsRegistry[:source_providers, type],
    ComponentsRegistry[:target_builders, type],
    ComponentsRegistry[:test_runners, type],
    ComponentsRegistry[:report_builders, type]
  ].select { |x| not x.nil? }.first.params_definition.select { |x| not x[:hidden] }

  json params_definition
end