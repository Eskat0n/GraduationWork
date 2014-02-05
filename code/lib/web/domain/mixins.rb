module SHR
  module Domain

    class Dto
      def metaclass
        class << self
          self
        end
      end

      def define_attribute name, value
        metaclass.send :attr_accessor, name.to_sym
        send "#{name}=".to_sym, value
      end
    end

    module Transferable
      def to_dto
        dto = Dto.new
        properties.each do |prop|
          value = method(prop.name.to_sym).()
          dto.define_attribute(prop.name, value)
        end
        return dto
      end
    end

  end
end
