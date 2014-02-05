# coding: utf-8

class DummySourceProvider < SourceProviderComponent
  #register!

  def initialize params
    explode_params(params)
  end

  def self.name
    'Компонент-заглушка'
  end

  def self.params_definition
    [
      { :name => 'first_param', :description => 'Этот параметр ничего не делает' },
      { :name => 'second_param', :description => 'Этот параметр тоже ничего не делает' }
    ]
  end
end
