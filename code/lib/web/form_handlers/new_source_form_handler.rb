# coding: utf-8

class NewSourceFormHandler
  def validate form
    vresult = ValidationResult.new

    name = form[:source][:name]
    if name.nil? or name.size == 0
      vresult.add_error 'source[name]', 'Необходимо указать название источника исходных кодов'
    end

    type = form[:source][:type]
    components_count = ComponentsRegistry.source_providers.count { |sp| sp.type.to_s == type }
    if components_count == 0
      vresult.add_error 'source[type]', 'Несуществующий тип компонента поставщика исходных кодов'
    end

    vresult
  end

  def handle form
    source_form = form[:source]
    params = form[:param].nil? ? {} : Hash[form[:param].collect { |k,v| [v[:name], v[:value]] }]

    source = Source.create({
      :name => source_form[:name],
      :type => source_form[:type],
      :params => params.delete_if { |k,v| v === '' }
    })
    source.save
    source
  end
end
