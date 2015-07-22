class SimpleNormals
  prepend Hashstructor

  member :shaq, value_type: Integer, required: true, attr_kind: :reader
  member :chuck, value_type: Float, required: true, attr_kind: :reader
  member :kenny, value_type: Symbol, required: true, attr_kind: :reader
  member :ernie, value_type: String, required: true, attr_kind: :reader
end