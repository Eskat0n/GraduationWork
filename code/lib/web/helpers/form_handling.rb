helpers do
  def handle(type, form, results)
    fail = results[:fail] or results[:success]

    handler = type.new

    vresult = handler.validate(form)
    unless vresult.valid?
      @errors = vresult.errors
      return fail.()
    end
    
    begin
      @handle_result = handler.handle(form)
    rescue FormHandlerError
      return fail.()
    end

    results[:success].()
  end
end