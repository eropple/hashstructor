module Hashstructor
  # A member within a Hashstructor class that should be populated by the hash
  # passed into {Hashstructor#initialize}.
  class Member
    # The allowed {#member_type}s for a `Member`:
    #
    # - `:normal` - a normal value. raises error if hash or array given unless
    #               the `:no_collections` option is set.
    # - `:hash` - a hash, with all keys symbolized unless the `:string_keys`
    #             option is set.
    # - `:array` - an array
    # - `:set` - a set
    #
    # Note that these types refer to the "collection status" of the member. A
    # `:normal` member will happily accept any value unless a `:custom_type`
    # option is passed.
    VALID_MEMBER_TYPES = [ :normal, :hash, :set, :array ].freeze

    # @return [Symbol] the name of the member, in the parsed hash.
    attr_reader :name

    # @return [Symbol] the type of the member; see {VALID_MEMBER_TYPES}.
    attr_reader :member_type

    # A hash of Class => Proc converters for value types. Any value type
    # in this list, as well as any class that includes or prepends
    # `Hashstructor`, is valid for {#value_type}. This is _intentionally_
    # not frozen; if you want to extend it for your own use cases, I'm not
    # going to get in your way.
    VALID_VALUE_TYPES = {
      String => Proc.new do |v|
        v.to_s
      end,
      Symbol => Proc.new do |v|
        v.to_sym
      end,
      Integer => Proc.new do |v|
        Integer(v.to_s)
      end,
      Float => Proc.new do |v|
        Float(v.to_s)
      end,
      TrueClass => Proc.new do |v|
        !!v
      end,
      FalseClass => Proc.new do |v|
        !!v
      end,
    }
    # Determines the class that Hashstructor should attempt to coerce a
    # given value into. For example, `Fixnum` will attempt to coerce a
    # scalar value into a `Fixnum`.
    #
    # The valid types for {#value_type} are:
    #
    # - `String`
    # - `Symbol`
    # - `Integer`
    # - `Float`
    # - `TrueClass` or `FalseClass` (for booleans)
    # - any class that includes or prepends `Hashstructor`
    #
    # @return [(nil, Class)] the type of the value stored in this member.
    attr_reader :value_type

    @required = false
    # If true, attempting to construct this object without setting this
    # member will raise an error.
    attr_reader :required

    # Specifies what type of attr (nil, `:reader`, or `:accessor`) that this
    # member should define on its class.
    #
    # @return [(nil, :reader, :accessor)] the type of attr to create.
    attr_reader :attr_kind

    # @return [Hash] a (frozen) set of all extra options passed to the member.
    attr_reader :options

    def initialize(klass, name, options)
      member_type = options[:member_type] || :normal
      options.delete(:member_type)
      value_type = options[:value_type]
      options.delete(:value_type)
      required = !!(options[:required])
      options.delete(:required)
      attr_kind = options[:attr_kind]
      options.delete(:attr_kind)

      @options = options.freeze

      raise HashstructorError, "'name' must respond to :to_sym." unless name.respond_to?(:to_sym)
      @name = name.to_sym

      raise HashstructorError, "'member_type' (#{member_type}) must be one of: [ #{VALID_MEMBER_TYPES.join(", ")} ]" \
        unless VALID_MEMBER_TYPES.include?(member_type.to_sym)

      @member_type = member_type.to_sym

      raise HashstructorError, "'value_type' must be nil or a Class." \
        unless value_type == nil || value_type.is_a?(Class)
      raise HashstructorError, "'value_type' class, #{value_type.name}, must be in " +
            "VALID_VALUE_TYPES ([ #{VALID_VALUE_TYPES.keys.map { |c| c.name}.join(", ")} ]) " +
            "or include or prepend Hashstructor." \
        unless value_type == nil || VALID_VALUE_TYPES[value_type] != nil || value_type.ancestors.include?(Hashstructor)

      @value_type = value_type

      @required = required

      case attr_kind
      when nil
        # do nothing
      when :reader
        klass.send(:attr_reader, @name)
      when :accessor
        klass.send(:attr_accessor, @name)
      else
        raise HashstructorError, "Unrecognized attr_kind: #{attr_kind}"
      end
      @attr_kind = attr_kind
    end

    # Parses the passed-in value (always a single item; {InstanceMethods#hashstruct} handles
    # the breaking down of arrays and hashes) and returns a value according to {#value_type}.
    def parse_single(value)
      if value_type.nil?
        value
      elsif value_type.ancestors.include?(Hashstructor)
        raise HashstructorError, "No hash provided for building a Hashstructor object." unless value.is_a?(Hash)

        value_type.new(value)
      else
        VALID_VALUE_TYPES[value_type].call(value)
      end
    end
  end
end