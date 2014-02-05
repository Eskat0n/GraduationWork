helpers do
  def validation_message name
    if (not @errors.nil?) and (not @errors[name].nil?)
      @errors[name]
    end
  end
end
