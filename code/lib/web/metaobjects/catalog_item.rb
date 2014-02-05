class CatalogItem
  attr_reader :value, :name

  def initialize value, name
    @value, @name = value, name
    @selected = false
  end

  def select!
    @selected = true
  end

  def deselect!
    @selected = false
  end

  def selected?
    @selected
  end
end
