class ValidationClass
  prepend Hashstructor
  
  member :shaq, value_type: Symbol, required: true, attr_kind: :reader,
                validation: lambda { |v, err|
                              err << "must be foo" unless v == :foo
                            }
end