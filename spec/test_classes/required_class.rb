class RequiredClass
  prepend Hashstructor

  member :shaq, value_type: Integer, required: true, attr_kind: :reader
  member :chuck, value_type: Integer, required: false, attr_kind: :reader
end