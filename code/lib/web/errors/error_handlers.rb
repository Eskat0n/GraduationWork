# coding: utf-8

error not_found do
  @name, @type = 'Ошибка - Не найдено (404)', nil

  @description = 'Страница которую вы запрашиваете не найдена.'
  @message = request.env['sinatra.error'].message
  # some sort of hack since Sinatra don't put any message to Sinatra::NotFound error class
  @message = nil if @message == request.env['sinatra.error'].class.to_s

  @mail_link = nil
  
  haml :error
end

error do
  @name, @type = 'Ошибка - Внутренняя ошибка сервера (500)', request.env['sinatra.error'].class.to_s

  @description = 'При обработке вашего запроса произошла ошибка.'
  @message = request.env['sinatra.error'].message
  # some sort of hack since Sinatra don't put any message to Sinatra::NotFound error class
  @message = nil if @message == request.env['sinatra.error'].class.to_s

  @mail_link = mail_link(SHR::Config.developer_email,
    :subject => 'Error report (500)',
    :body => "Error of type #{@type} occurred while serving #{request.path_info} to user.\nError message: #{@message}")
  
  haml :error
end