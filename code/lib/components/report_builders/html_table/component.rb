# coding: utf-8

require 'erb'

class HTMLTableReportBuilder < ReportBuilderComponent
  register!

  @@MYDIR = get_mydir(__FILE__)
  @@BUILTIN_TEMPLATE = File.join(@@MYDIR, 'report_template.erb')

  def initialize params
    explode_params(params)
    @date = Time.now.strftime('%d.%m.%y %H:%M')
  end

  def build_report
    # read specified template file contents
    template = ERB.new(File.open(@opt_template) { |io| io.read })

    # make report filename using project id and current timestamp
    report_filename = "Report [Project ##{@project.id}] [#{@date.gsub(/:/, '-')}].html"
    report_filepath = File.join(@output, report_filename)

    # write generated project file contents
    File.open(report_filepath, 'w') { |io| io.write(template.result(binding)) }

    report_filepath
  end
  
  def self.name
    'Компонент для создания простых табличных отчетов в HTML разметке'
  end

  def self.params_definition
    [
      { :name => 'results', :required => true, :hidden => true },
      { :name => 'project', :required => true, :hidden => true },
      { :name => 'output', :description => 'Путь к папке, в которой будут сохранены файлы отчетов', :required => true },
      { :name => 'template', :description => 'Путь к файлу, содержащему erb-разметку таблицы отчета', :default => @@BUILTIN_TEMPLATE },
    ]
  end
end
