# coding: utf-8

class ComponentsLoader
  @@last = nil

  def self.<< value
    @@last = value
  end

  def onload &block
    @onload = block
  end

  def onerror &block
    @onerror = block
  end

  def load_from path
    if File.directory?(path)
      Dir.foreach path do |filename|
        next if filename[0] == '.'

        component_path = File.join(path, filename)
        next unless File.directory?(component_path)

        component_filename = File.join(component_path, 'component.rb')
        if File.file?(component_filename)
          load component_filename

          if @@last.nil?
            error "Компонент, находящийся в директории #{component_path} загружен, но не зарегистрирован"
          else
            if @@last.name.nil?
              error "Для компонента типа #{@@last.type} не указано название"
              next
            end
            if @@last.type.nil?
              error "У компонента с именем #{@@last.name} неправильно выставлен тип"
              next
            end
            
            @onload.(@@last.type, @@last.base_type) unless @onload.nil?
            yield @@last
            @@last = nil
          end
        end
      end
    end
  end

  private
  def error message
    @onerror.(message) unless @onerror.nil?
  end
end
