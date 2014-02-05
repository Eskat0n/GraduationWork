require 'iconv'

class Unpacker
  def initialize szip_path
    @szip_path = szip_path
  end

  def unpack archive_path, to
    IO.popen(%Q{"#{@szip_path}" x -o#{to} "#{archive_path}"}).close
  end
end