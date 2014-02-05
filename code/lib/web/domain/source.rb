class Source
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
  before :destroy do |source|
    throw :halt unless source.projects.emtpy?
  end
end
