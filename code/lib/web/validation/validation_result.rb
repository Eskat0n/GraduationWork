class ValidationResult
  attr_reader :errors

  def initialize 
    @errors = {}
  end

  def add_error key, message
    @errors[key] = message
  end

  def each &block
    @erros.each_pair &block
  end

  def valid?
    @errors.empty?
  end
end
