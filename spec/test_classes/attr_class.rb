class AttrClass
  prepend Hashstructor

  member :shaq, value_type: Integer, required: true, attr_kind: nil
  member :chuck, value_type: Integer, required: true, attr_kind: :reader
  member :kenny, value_type: Integer, required: true, attr_kind: :accessor
end