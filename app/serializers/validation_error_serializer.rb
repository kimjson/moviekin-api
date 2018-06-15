# frozen_string_literal: true

# Serializer for single field invalidness
class ValidationErrorSerializer
  def initialize(record, field, details)
    @record = record
    @field = field
    @details = details
  end

  def serialize
    @details.map do |detail|
      {
        "status": 422,
        "source": { "pointer": "/data/attributes/#{field}" },
        "title": "Invalid #{resource}",
        "detail": detail
      }
    end
  end

  private

  def resource
    @record.class.to_s
  end

  def field
    @field.to_s
  end
end
