# coding: utf-8

class NewTestConfigFormHandler
  def validate form
    vresult = ValidationResult.new

    name = form[:test_config][:name]
    if name.nil? or name.size == 0
      vresult.add_error 'test_config[name]', 'Необходимо указать название конфигурации запуска тестов'
    end

    type = form[:test_config][:type]
    components_count = ComponentsRegistry[:test_runners].count { |tr| tr.type.to_s == type }
    if components_count == 0
      vresult.add_error 'test_config[type]', 'Несуществующий тип компонента запуска тестов'
    end

    vresult
  end

  def handle form
    test_config_form = form[:test_config]
    params = form[:param].nil? ? {} : Hash[form[:param].collect { |k,v| [v[:name], v[:value]] }]
    
    test_config = TestConfiguration.create({
      :name => test_config_form[:name],
      :type => test_config_form[:type],
      :params => params.delete_if { |k,v| v === '' }
    })
    test_config.save
    test_config
  end
end
