module Exceptions
  class RecordNotFound < StandardError
    def initialize(model, id)
      @title = "#{model} not found"
      @detail = "Cannot find #{model} record with ID #{id}"
    end
  end
  
  class RecordInvalid < StandardError
    def initialize(model, attribute, detail)
      @title = "#{model} Invalid"
      @detail = "#{attribute}: #{detail}"
      @source = "/data/attributes/#{attribute}"
    end
  end
    
end