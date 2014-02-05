module SHR
  class HelpLibrary
    attr_reader :index

    @@library = nil
   
    def self.get
      @@library
    end
    
    def self.build path
      @@library = HelpLibrary.new(path)
    end

    private
    def initialize path
      @index = HelpIndex.new(path)
    end
  end
end
