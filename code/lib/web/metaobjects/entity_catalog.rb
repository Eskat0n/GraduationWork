require_relative 'catalog.rb'

class EntityCatalog < Catalog
  def initialize entity_type
    super(entity_type.all, :id, :name)
    prepend('0', '---', true)
  end
end
