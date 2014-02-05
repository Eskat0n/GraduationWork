def load_all_from path 
  Dir.foreach path do |filename|
    extension = File.extname filename
    next if filename == '.' or filename == '..' or extension != '.rb'
    load File.join(path, filename)
  end
end