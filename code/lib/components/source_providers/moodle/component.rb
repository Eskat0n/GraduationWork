# coding: utf-8

require 'uuid'

require_relative 'moodle_service_client.rb'
require_relative 'unpacker.rb'

class MoodleSourceProvider < SourceProviderComponent
  register!

  def initialize params
    explode_params(params)
    @client = MoodleServiceClient.new(@host, @token)
    @unpacker = Unpacker.new(@szip_path)
  end

  def pull from_revision
    # get list of submissions from Moodle uploaded since last pull
    submissions = @client.get_submissions(@assignment, (from_revision.to_i or 0))
    
    unless submissions.empty?
      # create new revision as time value (in seconds) taken from max "timemodified" field
      new_revision = submissions.collect { |x| x[:timemodified] }.sort.last

      #create temp directory for this pull
      @temp_dir = get_temp

      # begin receiving submission files from Moodle
      pulled_dirs = submissions.collect do |sm|
        file_content = @client.get_submission_file(sm[:id])[:content]

        # save file content as temp archive file
        temp_archive = File.join(@temp_dir, UUID.generate(:compact) + File.extname(sm[:filename]))
        File.open(temp_archive, 'wb') { |fio| fio.write(file_content) }

        # make directory path for pulled project
        extract_to_path = File.join(@temp_dir, UUID.generate(:compact))

        # unpack file contents and remove temp archive file
        @unpacker.unpack(temp_archive, extract_to_path)
        File.delete(temp_archive)

        [ "#{sm[:username]} - #{File.basename(sm[:filename])}", extract_to_path ]
      end.hashize

      PullResult.new(pulled_dirs, new_revision)
    else
      # if there are no changes pulled create empty PullResult
      PullResult.new([], nil)
    end
  end

  def self.name
    'Компонент для работы с Moodle'
  end

  def self.params_definition
    [
      { :name => 'host', :description => 'Адрес, по которому расположен портал на базе Moodle', :required => true },
      { :name => 'token', :description => 'Токен авторизации для работы с сервисом', :required => true },
      { :name => 'assignment', :description => 'Название задания в Moodle', :required => true },
      { :name => 'szip_path', :description => 'Путь к исполняемому файлу архиватора 7-zip', :required => true }
    ]
  end
end
