class MSBuildRunner
  @@MSBUILD_ERROR_REGEX = /([^\(]+)(\((\d+)\))?\s?: (fatal )?error ([\w\d]+): (.*)$/
  @@MSBUILD_WARNING_REGEX = /([^\(]+)(\((\d+)\))?\s?: warning ([\w\d]+): (.*)$/

  attr_reader :path
  attr_accessor :project, :args

  def initialize path
    @path = path
  end

  def run project, args = {}
    @project, @args = project, args
    run_build
  end

  private
  def run_build
    raise NoProjectFileProvidedError if @project.nil?

    exec = %Q{\"#{@path}\" \"#{@project}\" }
    @args.each_pair do |key, val|
      exec += "/#{key}:#{val} "
    end unless @args.nil?

    build_warnings, build_errors = [], []
    IO.popen exec.to_winpath do |io|
      io.each do |line|
        line = line.from_winpath

        if (not (line =~ @@MSBUILD_WARNING_REGEX).nil?)
          build_warnings << {
            :file => $1,
            :line => $3,
            :code => $4,
            :message => $5
          }
        elsif (not (line =~ @@MSBUILD_ERROR_REGEX).nil?)
          build_errors << {
            :file => $1,
            :line => $3,
            :fatal => (not $4.nil?),
            :code => $5,
            :message => $6
          }
        end
      end
    end

    [build_warnings, build_errors]
  end
end

class NoProjectFileProvidedError < Exception
end