class ErrorSerializer < ActiveModel::Serializer
  attribute :error_messages do
    object.errors.full_messages
  end
end
