TOKENS = []

get '/logon' do
  haml :logon, :locals => {:error => false}
end

post '/logon' do
  credentials = SHR::Config.user

  if (credentials['login'] == params[:login] and credentials['password'] == params[:password])   
    TOKENS << (session[:shr_token] = UUID.generate(:compact))

    redirect to('/')
  else
    haml :logon, :locals => {:error => true}
  end
end

get '/logoff' do
  TOKENS.delete(session[:shr_token]) unless session[:shr_token].nil?
  redirect to('/logon')
end

helpers do
  def authorized?    
    TOKENS.include?(session[:shr_token]) or settings.environment == :development
  end
end