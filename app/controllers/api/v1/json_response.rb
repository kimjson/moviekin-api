class JsonResponse
  def initialize(serializer)
    @serializer = serializer
  end

  def send(params: {}, **kwargs)
    options = {}
    options[:include] = params[:include].split(',') if params.key? :include

    payload = kwargs.extract!(:status, :location)
    payload[:json] = @serializer.new(kwargs[:data], options)

    render payload
  end
end