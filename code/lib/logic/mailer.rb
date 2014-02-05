# coding: utf-8

require 'pony'

module SHR
  class Mailer
    def initialize
      smtp_host = SHR::Config.smtp['host']
      raise 'Could not send emails because no SMTP server is specified' if smtp_host.nil?

      @from = SHR::Config.email_from or 'mailer@sledgehammer.cc'
      @smtp = {
        :address => smtp_host,
        :port => (SHR::Config.smtp['port'] or '25')
      }

      user, password = SHR::Config.smtp['user'], SHR::Config.smtp['password']
      @smtp[:user_name], @smtp[:password] = user, password unless user.nil? or password.nil?
    end

    def send_report email_address, project_name, report_path
      body = "В системе #{INSTANCE_NAME} создан отчет по тестированию для проекта #{project_name} [#{Time.now.to_longtime}]"
      body += "\nВы получили данное письмо, т.к. являетесь ответственным за проект #{project_name}"
      body += "\nЕсли это не так, то вы можете связаться с администратором системы #{INSTANCE_NAME}, "
      body += "написав сообщение на адрес электронной почты #{SHR::Config.admin_email}"

      Pony.mail(
        :to => email_address,
        :from => @from,
        :charset => 'utf-8',
        :body => body,
        :via => :smtp,
        :via_options => @smtp
       # :attachments => { File.basename(report_path) => File.read(report_path) },        
      )
    end
  end
end
