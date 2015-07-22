class NestedObject
  prepend Hashstructor

  member :ernie, value_type: Integer, required: true, attr_kind: :reader
end

class TopObject
  prepend Hashstructor

  member :shaq, value_type: NestedObject, required: true, attr_kind: :reader
  member :chuck, member_type: :array, value_type: NestedObject, required: true, attr_kind: :reader
  member :kenny, member_type: :hash, value_type: NestedObject, required: true, attr_kind: :reader

end