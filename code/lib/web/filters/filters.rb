set :not do |value|
  if value.class === Array
    condition { not value.include?(value) }
  else
    condition { request.path_info != value }
  end
end