# coding: utf-8

get '/system/admin' do
  @start_time = LOGGER.start_time
  @work_time = Time.now.substract(@start_time)
  @published = SHR::Config.publish?

  @fatals_count = SHR::Consistency.fatals.size
  @warnings_count = SHR::Consistency.warnings.size

  overview :system_admin, 'Администрирование системы'
end

get '/system/power' do
  exit!
end

get '/system/logs' do  
  @logs = collect_logs

  details :system_logs, 'Просмотр журнала', :backlink_href => to('/system/admin'), :backlink_text => 'На страницу администрирования'
end

get '/system/log/:filename' do |filename|
  filepath = File.join(SHR::Config.log_path, filename)
  raise Sinatra::NotFound, 'Файл журнала не найден' unless (File.exists?(filepath) and File.extname(filepath) == '.log')

  logs = collect_logs.collect { |x| x[:filename] }
  index = logs.index(filename)
  @prev_log = index == 0 ? nil : logs[index-1]
  @next_log = index == logs.size-1 ? nil : logs[index+1]
  @is_current = LOGGER.current == filename
  
  @log_content = File.open(filepath, &:read).gsub(/\n/, '<br/>')
  
  details :system_log, "Просмотр файла журнала #{filename}#{@is_current ? ' [текущий]' : ''}",
    :backlink_href => to('/system/logs'), :backlink_text => 'К просмотру журнала'
end

get '/system/config' do
  overview :system_config, 'Изменение параметров конфигурации'
end

get '/system/state' do
  @fatals = SHR::Consistency.fatals
  @warnings = SHR::Consistency.warnings
  details :system_state, 'Обзор состояния системы', :backlink_href => to('/system/admin'), :backlink_text => 'На страницу администрирования'
end

get '/system/auth/' do
  redirect to('/system/auth/logon')
end

get '/system/auth/logoff' do
  redirect to('/')
end

helpers do
  def collect_logs
    Dir.glob(File.join(SHR::Config.log_path, '*.log'))
      .collect { |x| { :time => File.ctime(x), :filename => File.basename(x), :is_current => File.basename(x) == LOGGER.current } }
      .sort_by { |x| x[:time] }.reverse
  end
end