# coding: utf-8

helpers do
  def json data
    JSON[data]
  end

  def file_attachment path
    attachment File.basename(path)
    File.open(path)
  end
end