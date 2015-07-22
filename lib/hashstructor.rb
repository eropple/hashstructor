require "hashstructor/version"

module Hashstructor
  # You made Hashstructor sad and now you have this error.
  class HashstructorError < RuntimeError
  end
end

require "hashstructor/instance_methods"
require "hashstructor/class_methods"

# Allows the "hashstruction" of objects by predefining an {Hashstructor#initialize}
# method off of the {Hashstructor::InstanceMethods#member} declarations within the
# class spec.
#
# The secret sauce for this module is in {Hashstructor::InstanceMethods} and
# {Hashstructor::ClassMethods}, respectively.
module Hashstructor
  prepend Hashstructor::InstanceMethods

  # Fires when this module is `prepend`ed. This is the most cromulent way to
  # use Hashstructor in Ruby 2.x.
  def self.prepended(mod)
    Hashstructor.decorate(mod)
  end

  # Fires when this module is `include`d. This is provided for Ruby 1.9.x, but
  # classes that `include` this have to explicitly invoke
  # {Hashstructor::InstanceMethods#hashstruct}.
  def self.included(mod)
    Hashstructor.decorate(mod)
  end

  # The actual magic of both {Hashstructor#prepended} and {Hashstructor#included};
  # bolts the class methods onto the prepending/including module.
  def self.decorate(mod)
    mod.instance_variable_set("@hashstructor_members", [])
    mod.extend(Hashstructor::ClassMethods)
  end
end
