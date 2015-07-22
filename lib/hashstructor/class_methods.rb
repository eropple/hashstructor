require 'hashstructor/member'

module Hashstructor
  # Class methods for {Hashstructor} objects.
  module ClassMethods
    # @return [Array<Member>] all Hashstructor members for this class (frozen)
    def hashstructor_members
      @hashstructor_members.freeze
    end

    private
    # Defines a Hashstructor member to be placed on this object. See
    # {Member}'s documentation for expected values.
    def member(name, options = {})
      options[:member_type] ||= :normal

      options[:required] = !!(options[:required])

      @hashstructor_members << Hashstructor::Member.new(self, name, options).freeze
    end
  end
end