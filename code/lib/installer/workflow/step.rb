# coding: utf-8

module Installer
  class Step
    def initialize
      
    end

    def condition
      true
    end

    def act!
      raise 'Action part of #{self} must be implemented'
    end

    protected
    def ask question
      print "#{question} (y/n) "
      begin
        @responce = gets.strip.upcase
      end until ['Y', 'N'].include?(@responce)
      @responce == 'Y'
    end
  end
end
