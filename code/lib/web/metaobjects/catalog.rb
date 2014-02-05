require_relative 'catalog_item.rb'

class Catalog
  include Enumerable

  def initialize collection, value_key, name_key, selected_value=nil
    value_getter = value_key.to_proc
    name_getter = name_key.to_proc

    @items = collection.collect do |x|
      value = value_getter.(x)
      name = name_getter.(x)

      item = CatalogItem.new(value, name)
      item.select! if not selected_value.nil? and value == selected_value
      item
    end
    @items.first.select! if selected_value.nil? and not @items.empty?
  end

  def each &block
    @items.each &block
  end

  def prepend value, name, selected=false
    @items = [CatalogItem.new(value, name)] + @items

    if selected
      @items.each { |x| x.deselect! }
      @items.first.select!
    end

    self
  end

  def append value, name, selected=false
    @items << CatalogItem.new(value, name)

    if selected
      @items.each { |x| x.deselect! }
      @items.last.select!
    end

    self
  end
end
