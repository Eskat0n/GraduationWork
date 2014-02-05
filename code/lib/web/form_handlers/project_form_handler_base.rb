# coding: utf-8

class ProjectFormHandlerBase
  def validate form
    vresult = ValidationResult.new

    title = form[:project][:title]
    if title.nil? or title.size == 0
      vresult.add_error 'project[title]', 'Необходимо указать наименование проекта'
    end

    email = form[:project][:email]
    if (not email.empty?) and (email =~ /^[a-zA-Z0-9_.\-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9\-.]+$/).nil?
      vresult.add_error 'project[email]', 'Email имеет неправильный формат'
    end

    interval = form[:project][:interval]
    unless interval.empty?
      if (interval =~ /^\d*$/).nil?
        vresult.add_error 'project[interval]', 'Интервал обновления должен быть целым числом'
      elsif interval.to_i <= 30
        vresult.add_error 'project[interval]', 'Интервал обновления не может быть меньше 30 секунд'
      end
    end

    source_id = form[:project][:source].to_i
    if source_id.nil? or (source_id != 0 and Source.get(source_id).nil?)
      vresult.add_error 'project[source]', 'Несуществующий источник исходных кодов'
    end

    report_config_id = form[:project][:report_config].to_i
    if report_config_id.nil? or (report_config_id != 0 and ReportConfiguration.get(report_config_id).nil?)
      vresult.add_error 'project[report_config]', 'Несуществующая конфигурация отчетов'
    end

    vresult
  end
end
