# coding: utf-8

require 'fileutils'

class FileSystemSourceProvider < SourceProviderComponent
  register!

  REVISIONS_FILENAME = '.revisions'

  def initialize params
    explode_params(params)
    @path = @path.to_winpath
  end

  def pull from_revision    
    revisions = []

    revisions_filename = File.join(@path, REVISIONS_FILENAME)

    # create revisions file
    File.new(revisions_filename, 'w').close unless File.exist? revisions_filename

    # read all revisions from existing file
    File.open(revisions_filename) do |fio|
      revisions = fio.lines.to_a.collect { |line| parse_revision(line.chomp) }
    end

    # get all revisions than lies above 'from' revision
    to_top = revisions.select { |x| x[:rev] > (from_revision.to_i or 0) }
    to_top_dirs = to_top.collect { |x| x[:dirs] }.flatten

    # get list of new directories (not versioned)
    new_dirs = detect_new(revisions)

    # process new directories which don't belongs to any revision
    # if we are not on top revision copy all directories to temp process them too
    dirs_to_pull = to_top_dirs + new_dirs
    @temp_dir = get_temp unless dirs_to_pull.empty?
    dirs_to_pull.each { |dir| FileUtils.cp_r(dir, @temp_dir) }

    unless dirs_to_pull.empty?
      # set new revision to number next to max rev number from revisions file
      new_revision = revisions.empty? ? 1 : revisions.collect { |x| x[:rev] }.sort.last

      # convert directories paths from windows locale to UTF-8
      dirs_to_pull.collect! &:from_winpath

      # write new revision line to revisions file if we are was on top
      File.open(revisions_filename, 'a') do |fio|
        fio.puts "#{new_revision}:#{dirs_to_pull.collect { |x| File.basename(x) }.join(',')}"
      end if to_top.empty?

      # assume base name of pulled directory name as name of target (project in normal terms)
      pulled_dirs = dirs_to_pull.collect { |x| 
        [ File.basename(x), File.join(@temp_dir, File.basename(x)) ]
      }.hashize
      # form pull results
      PullResult.new(pulled_dirs, new_revision)
    else
      # if there are no changes pulled create empty PullResult
      PullResult.new([], nil)
    end
  end

  def self.name
    'Компонент для работы с папками в файловой системе'
  end

  def self.params_definition
    [
      { :name => 'path', :description => 'Путь к папке, из которой будут забираться исходные коды', :required => true },
    ]
  end

  private
  def detect_new revisions
    old_dirs = revisions.collect { |x| x[:dirs] }.flatten    
    Dir.entries(@path)
      .select { |x| x[0] != '.' }
      .collect { |x| File.join(@path, x) }
      .select { |x| File.directory?(x) and (not old_dirs.include?(x)) }
  end

  private
  def parse_revision line
    rev, dirs = line.split(':')
    { :rev => rev.to_i, :dirs => dirs.split(',').collect { |x| File.join(@path, x).to_winpath } }
  end
end
