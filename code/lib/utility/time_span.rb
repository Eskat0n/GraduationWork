class TimeSpan
  attr_reader :day, :hour, :min, :sec

  def initialize sec
    @total_sec = sec
    @day, @hour, @min, @sec = conv(86400), conv(3600), conv(60), sec % 60
  end

  def strftime format
    format
      .gsub(/%d/, @day.to_s)
      .gsub(/%H/, @hour.to_s)
      .gsub(/%M/, @min.to_s)
      .gsub(/%S/, @sec.to_s)
  end

  private
  def conv base
    (@total_sec / base) % base
  end
end
