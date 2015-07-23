require 'set'

module Hashstructor
  # Instance methods for {Hashstructor} objects.
  module InstanceMethods
    private
    # Initializes the object. This exists for objects that `prepend`
    # {Hashstructor}; objects that `include` it must explicitly invoke
    # {#hashstruct} within their own `initialize` method.
    #
    # @param hash [Hash] the hash from which to parse the object data
    def initialize(hash)
      hashstruct(hash)
    end

    # Constructs the object from the given hash, based on the metadata fed
    # in by {ClassMethods#member} invocations.
    #
    # @param hash [Hash] the hash from which to parse the object data
    def hashstruct(hash)
      raise HashstructorError, "hashstruct expects a hash." unless hash.is_a?(Hash)

      members = self.class.hashstructor_members

      # This could be done inline, but I'd rather loop twice and get this check
      # out of the way ahead of time because of the perf hit when dealing with
      # deeply nested structures.
      partitioned_members = members.partition { |m| hash[m.name] || hash[m.name.to_s] }

      existing_members = partitioned_members[0]
      missing_members = partitioned_members[1]

      partitioned_missing_members = missing_members.partition { |m| !m.required || (m.required && m.options[:default_value]) }

      acceptable_missing_members = partitioned_missing_members[0]
      unacceptable_missing_members = partitioned_missing_members[1]

      raise HashstructorError, "Missing required members: #{unacceptable_missing_members.map { |m| m.name }.join(", ")}" \
        unless unacceptable_missing_members.empty?

      acceptable_missing_members.each do |member|
        out_value = case member.member_type
                      when :normal
                        member.options[:default_value]
                      when :array
                        []
                      when :set
                        Set.new
                      when :hash
                        {}
                    end

        instance_variable_set("@#{member.name}", out_value)
      end

      existing_members.each do |member|
        raw_value = hash[member.name] || hash[member.name.to_s]
        out_value = nil

        case member.member_type
          when :normal
            raise HashstructorError, "member '#{member.name}' expects a single value, got #{raw_value.class.name}." \
              if member.options[:no_collections] && raw_value.is_a?(Enumerable)

            out_value = member.parse_single(raw_value)

          when :hash
            raise HashstructorError, "member '#{member.name}' expects a Hash, got #{raw_value.class.name}." \
              unless raw_value.is_a?(Hash)

            out_value = {}
            raw_value.each_pair do |k, v|
              key = member.options[:string_keys] ? k.to_s : k.to_s.to_sym

              out_value[key] = member.parse_single(v)
            end

          when :array, :set
            raise HashstructorError, "member '#{member.name}' expects an Enumerable, got #{raw_value.class.name}"\
              unless raw_value.is_a?(Enumerable)

            out_value = raw_value.map { |v| member.parse_single(v) }

            out_value = out_value.to_set if member.member_type == :set
        end

        instance_variable_set("@#{member.name}", out_value)
      end
    end
  end
end