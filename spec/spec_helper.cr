require "spec"
require "../src/cgl"

class Foo
  property str : String

  def initialize(@str : String)
  end

  def_equals_and_hash @str
  def_clone
end
