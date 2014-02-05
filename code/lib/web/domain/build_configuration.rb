class BuildConfiguration
  include DataMapper::Resource
  include SHR::Domain::Transferable

  property :id,                   Serial
  property :name,                 String
  property :type,                 String
  property :params,               Yaml

  has n, :projects, :through => Resource
  
  def to_text
    "#{@name} (id=#{@id})"
  end

  # hooks
  before :destroy do |build_config|
    throw :halt unless build_config.projects.emtpy?
  end
end
