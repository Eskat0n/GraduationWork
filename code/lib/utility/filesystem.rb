require 'fileutils'

class Dir
  def self.cleanup path
    FileUtils.rm_r(Dir.glob(path+'/*').collect { |x| x.to_winpath })
  end

  def self.exists? path
    File.exists?(path) and File.directory?(path)
  end

  def self.exist? path
    self.exists? path
  end

  def self.create_if_none path
    mkdir(path) unless Dir.exists?(path)
  end
end