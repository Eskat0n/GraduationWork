class Array
  def hashize
    Hash[self]
  end
end

class Time
  def to_longtime
    self.strftime('%d.%m.%y %H:%M:%S')
  end

  def to_filename_time
    self.strftime('%d-%m-%y_%H-%M-%S')
  end

  def substract time
    TimeSpan.new (self - time).round
  end
end

class String
  def underscorize
    self.gsub(/\s/, '_')
  end
end