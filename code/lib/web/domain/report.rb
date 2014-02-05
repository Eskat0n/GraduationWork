class Report
  include DataMapper::Resource
  include SHR::Domain::Transferable

  property :id,                   Serial
  property :filename,             String
  property :path,                 String
  property :date,                 DateTime

  belongs_to :project
  belongs_to :report_configuration

  def report_config
    self.report_configuration
  end

  def report_config= value
    self.report_configuration = value
  end
end
