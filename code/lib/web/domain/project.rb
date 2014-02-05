# coding: utf-8

class Project
  include DataMapper::Resource
  include SHR::Domain::Transferable

  @@STATES = Enum[ :idle, :pulling, :building, :testing, :reporting ]

  property :id,                   Serial
  property :title,                String
  property :description,          String,       :required => false, :length => 65535
  property :maintainer_email,     String,       :length => 255
  property :interval,             Integer,      :default => 60
  property :state,                @@STATES,     :default => :idle
  property :revision,             String

  has 1, :source, :through => Resource, :constraint => :skip
  has 1, :build_configuration, :through => Resource, :constraint => :skip
  has 1, :test_configuration, :through => Resource, :constraint => :skip
  has 1, :report_configuration, :through => Resource, :constraint => :skip
  has n, :reports, :constraint => :destroy

  def to_text
    "#{@title} (id=#{@id})"
  end

  def build_config
    self.build_configuration
  end

  def build_config= value
    self.build_configuration = value
  end

  def test_config
    self.test_configuration
  end

  def test_config= value
    self.test_configuration = value
  end

  def report_config
    self.report_configuration
  end

  def report_config= value
    self.report_configuration = value
  end

  def state_description
    {
      idle: 'Ожидание',
      pulling: 'Получение исходных кодов',
      building: 'Сборка целей',
      testing: 'Тестирование целей',
      reporting: 'Создание отчета'
    }[self.state]
  end

  # hooks
  after :create do |project|
    project.maintainer_email = nil if (not project.maintainer_email.nil?) and project.maintainer_email.empty?
    project.interval = 60 if project.interval == 0
  end
end
