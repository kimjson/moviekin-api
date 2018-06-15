# frozen_string_literal: true

# common response method module.
module Response
  SERIALIZER_MAP = {
    'Movie' => MovieSerializer,
    'Question' => QuestionSerializer,
    'Answer' => AnswerSerializer
  }.freeze

  def get_serializer(data)
    record = data.respond_to?('each') ? data[0] : data
    SERIALIZER_MAP[record.class.to_s]
  end

  def json_response(args)
    serializer = get_serializer(args[:data])

    options = {}
    options[:include] = params[:include].split(',') if params.key? :include

    payload = args.extract!(:status, :location)
    payload[:json] = serializer.new(args[:data], options)

    render payload
  end
end
