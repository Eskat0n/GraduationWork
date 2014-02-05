module SHR
  class Task
    attr_reader :project_id, :interval

    def initialize project_id, interval, &block
      @project_id, @interval = project_id, interval
      @onkill = block

      @loop = Thread.start(@project_id, @interval) { |x,y| main_loop(x, y) }
    end

    def kill!
      @loop.exit
      @onkill.(self)
    end

    private
    def main_loop project_id, interval
      current_thread = nil

      loop do
        if (not current_thread.nil?) and current_thread.alive?
          log "Current pipeline thread for project with id=#{project_id} still working. Sleep for another #{interval} seconds"
        else
          current_thread = Thread.start(project_id, self) do |x, z|
            begin
              CommonPipeline.new(x).act!
            rescue NoProjectFoundError
              log "No project found for id given (id=#{x})"
              z.kill!
            end
          end
        end

        sleep(interval)
      end      
    end
  end
end
