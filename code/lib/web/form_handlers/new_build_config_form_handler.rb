# coding: utf-8

class NewBuildConfigFormHandler
  def validate form
    vresult = ValidationResult.new

    name = form[:build_config][:name]
    if name.nil? or name.size == 0
      vresult.add_error 'build_config[name]', 'Необходимо указать название конфигурации сборки'
    end

    type = form[:build_config][:type]
    components_count = ComponentsRegistry[:target_builders].count { |tb| tb.type.to_s == type }
    if components_count == 0
      vresult.add_error 'build_config[type]', 'Несуществующий тип компонента сборки целей'
    end

    vresult
  end

  def handle form
    build_config_form = form[:build_config]
    params = form[:param].nil? ? {} : Hash[form[:param].collect { |k,v| [v[:name], v[:value]] }]
    
    build_config = BuildConfiguration.create({
      :name => build_config_form[:name],
      :type => build_config_form[:type],
      :params => params.delete_if { |k,v| v === '' }
    })
    build_config.save
    build_config
  end
end
