require 'base64'

class MoodleServiceClient
  def initialize host, token
    url = "#{host.chomp('/')}/webservice/rest/server.php"    
    @client = SHR::Shared::ServiceClient.new(url, 'wsfunction', 'wstoken' => token)   
  end

  def get_submissions assignment, from_time
    @client.moodle_sledgehammer_get_submissions('assignment' => assignment, 'from_time' => from_time)
  end

  def get_submission_file file_id
    file = @client.moodle_sledgehammer_get_submission_file('file_id' => file_id)
    file[:content] = Base64.decode64(file[:content])
    file
  end
end
