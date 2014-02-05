# coding: utf-8

module Installer
  class Workflow
    def initialize *steps
      @steps = steps
    end

    def go!
      @steps.each { |step| step.act! if step.condition }
    end
  end
end
