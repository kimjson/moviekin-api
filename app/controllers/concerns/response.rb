# frozen_string_literal: true

# common response method module.
module Response
  SERIALIZER_MAP = {
    'Movie' => MovieSerializer,
    'Question' => QuestionSerializer,
    'Answer' => AnswerSerializer,
  }

  def get_serializer(data)
    record = data.respond_to?('each') ? data[0] : data
    return SERIALIZER_MAP[record.class.to_s]
  end

  def json_response(args)
    serialized_args = args.clone
    serialized_args[:json] = get_serializer(args[:data]).new(args[:data])
    render serialized_args
  end
end
