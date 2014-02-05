require 'iconv'

module Kernel
  def is_any_windows?
    is_windows? or is_windows_mingw? or is_windows_cygwin?
  end

  def is_windows?
    not RUBY_PLATFORM['mswin32'].nil?
  end

  def is_windows_mingw?
    not RUBY_PLATFORM['mingw'].nil?
  end

  def is_windows_cygwin?
    not RUBY_PLATFORM['cygwin'].nil?
  end
end

if is_any_windows?
  class String
    def to_winpath
      return self unless is_any_windows?
      Iconv.conv(SHR::Config.local_codepage, 'UTF-8', self)
    end

    def from_winpath
      return self unless is_any_windows?
      Iconv.conv('UTF-8', SHR::Config.local_codepage, self)
    end
  end

  # apply fix to encodings used for external and internal purposes
  Encoding.default_external = Encoding::UTF_8
end