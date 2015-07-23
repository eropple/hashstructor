class UnrequiredClass
  prepend Hashstructor

  member :shaq, member_type: :normal, value_type: Integer, required: false, attr_kind: :reader
  member :chuck, member_type: :array, value_type: Integer, required: false, attr_kind: :reader
  member :kenny, member_type: :set, value_type: Integer, required: false, attr_kind: :reader
  member :ernie, member_type: :hash, value_type: Integer, required: false, attr_kind: :reader
end