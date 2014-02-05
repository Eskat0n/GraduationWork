require_relative 'task.rb'

module SHR
  class Scheduler
    @@default = nil

    def self.default
      @@default
    end

    def initialize      
      @working = false
      @@default = self if @@default.nil?
    end

    def start      
      @tasks = Project.all.collect { |p| Task.new(p.id, p.interval) { |t| @tasks.delete(t) } }
      @working = true
    end

    def stop
      @tasks.each :kill! if @working
      @working = false
    end
	
    def spawn_task project
      (@tasks << Task.new(project.id, project.interval) { |t| @tasks.delete(t) }).last
    end

    def working?
      @working
    end
  end
end