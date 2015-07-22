class HashClass
  prepend Hashstructor

  member :shaq,  member_type: :hash, value_type: Integer, required: true, 
                 attr_kind: :reader, string_keys: false
  member :chuck, member_type: :hash, value_type: Integer, required: true, 
                 attr_kind: :reader, string_keys: true
end