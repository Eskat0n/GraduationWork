# coding: utf-8

require 'erb'
require 'uuid'

require_relative 'msbuild_runner.rb'

class VisualStudio10Builder < TargetBuilderComponent
  register!

  @@MYDIR = File.expand_path(File.dirname(__FILE__))
  @@BUILTIN_TEMPLATE = File.join(@@MYDIR, 'vsproject_template.erb')

  @@SYSTEM_ROOT = ENV['SystemRoot'].gsub(%r{\\}, '/') 

  @@HEADER_EXT = %w(h hpp hxx hm inl inc xsd)
  @@SOURCE_EXT = %w(cpp c cc cxx def odl idl hpj bat asm asmx)  
  
  def initialize params
    explode_params(params)
    @opt_header = @opt_header.split(';')
    @opt_source = @opt_source.split(';')

    # form *.vcxproj project filename
    @project_filename = File.join(@dir, 'project.vcxproj')
    # create miscs such as project guid and root namespace (both are uuids)
    @project_guid, @root_namespace = "{#{UUID.generate.upcase}}", UUID.generate(:compact)
  end

  def build
    # prepare project file (form it from template)
    prepare_project

    # get path to msbuild executable
    msbuild_path = get_msbuild
    # verify file specified by path exists
    raise MSBuildNotFoundError unless File.exists? msbuild_path

    # create MSBuild utility wrapper and run it
    build_runner = MSBuildRunner.new(msbuild_path)
    build_runner.run(@project_filename, 't' => 'Clean')
    warnings, errors = build_runner.run(@project_filename, 't' => 'Build', 'p' => 'Configuration=Debug', 'v' => 'm')

    # create build result for current target
    BuildResult.new(@dir, warnings, errors, File.join(@dir, 'Debug/project.exe'))
  end

  def prepare_project    
    # delete project file if it (by any chance) exists
    File.delete(@project_filename) if File.exists? @project_filename

    # aggregate all header files from given folder
    @header = list_files(@@HEADER_EXT)
    # aggregate all source files from given folder
    @source = list_files(@@SOURCE_EXT)

    # read built-in template file contents
    template = ERB.new(File.open(@@BUILTIN_TEMPLATE) { |fio| fio.read })
    # write generated project file contents
    File.open(@project_filename, 'w') { |fio| fio.write(template.result(binding)) }
  end

  def get_msbuild
    return @opt_msbuild unless @opt_msbuild.nil?
    lookup_path = File.join(@@SYSTEM_ROOT, '/Microsoft.NET/Framework/**/MSBuild.exe')
    Dir.glob(lookup_path).last
  end

  def list_files extensions
    extensions.collect { |x| Dir.glob(File.join(@dir.to_winpath, "**/*.#{x}")) }.flatten.collect &:from_winpath
  end

  def self.name
    'Компонент для сборки с использованием MSBuild и VC++'
  end

  def self.params_definition
    [
      { :name => 'dir', :required => true, :hidden => true },
      { :name => 'lib_path', :description => 'Пути к директориям, содержащим дополнительные библиотеки (разделитель – точка с запятой)', :default => '' },
      { :name => 'include_path', :description => 'Пути к директориям, содержащим дополнительные заголовочные файлы (разделитель – точка с запятой)', :default => '' },
      { :name => 'lib', :description => 'Пути к файлам дополнительных библиотек (разделитель – точка с запятой)', :default => '' },
      { :name => 'header', :description => 'Пути к дополнительным заголовочным файлам (разделитель – точка с запятой)', :default => '' },
      { :name => 'source', :description => 'Пути к дополнительным файлам исходного кода (разделитель – точка с запятой)', :default => '' },
      { :name => 'msbuild', :description => 'Путь к исполняемому файлу MSBuild (необязательно)' }
    ]
  end
end

class MSBuildNotFoundError < RuntimeError
end

