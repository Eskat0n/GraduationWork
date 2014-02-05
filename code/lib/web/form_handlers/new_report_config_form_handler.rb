# coding: utf-8

class NewReportConfigFormHandler
  def validate form
    vresult = ValidationResult.new

    name = form[:report_config][:name]
    if name.nil? or name.size == 0
      vresult.add_error 'report_config[name]', 'Необходимо указать название конфигурации отчетов'
    end

    type = form[:report_config][:type]
    components_count = ComponentsRegistry.report_builders.count { |rb| rb.type.to_s == type }
    if components_count == 0
      vresult.add_error 'report_config[type]', 'Несуществующий тип компонента построителя отчетов'
    end

    vresult
  end

  def handle form
    report_config_form = form[:report_config]    
    params = form[:param].nil? ? {} : Hash[form[:param].collect { |k,v| [v[:name], v[:value]] }]
    
    report_config = ReportConfiguration.create({
      :name => report_config_form[:name],
      :type => report_config_form[:type],
      :params => params.delete_if { |k,v| v === '' }
    })
    report_config.save
    report_config
  end
end
