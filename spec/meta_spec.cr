require "spec"
require "../src/meta"

describe "Meta" do
  it "should return all sub classes" do
    Foo.subclasses.should eq [Bar, Baz]
    Foo.all_subclasses.should eq [Bar, Baz, End]
  end

  it "should return classes methods" do
    Foo.class_methods.map(&.to_s).should eq ["def allocate()", "def new(arg : ::Int32 = 1)", "def cfoo()"]
  end

  it "should return all constant define in a class" do
    Foo.constants.should eq ["A"]
    Bar.constants.should eq [""]
  end

  it "should return ancestors of a class" do
    Bar.ancestors.should eq ["M",
                             "Foo",
                             "Reference",
                             "Object",
                             "Spec::ObjectExtensions",
                             "Colorize::ObjectExtensions"]
  end

  it "should return superclasses of a object" do
    Bar.new.superclasses.should eq ["Foo", "Reference", "Object"]
  end

  it "should return all the class this module included in" do
    M.includers.should eq ["Bar", "End"]
  end

  it "should all methods defined on a object" do
    Foo.new.methods.map(&.to_s).should eq ["def initialize(arg : ::Int32 = 1)", "def foo1()", "def foo2()"]
    Bar.new.methods.map(&.to_s).should eq ["def bar1()", "def bar2()"]
  end

  it "return instance variable defined on a object" do
    Foo.new.instance_vars.map(&.to_s).should eq ["@arg"]
  end

  it "return all methods can be invoked on a object seperated by class name" do
    Bar.new.all_methods.map(&.to_s).should eq ["{\"Bar\", [def bar1(), def bar2()]}",
                                               "{\"M\", [def m1(), def m2()]}",
                                               "{\"Foo\", [def initialize(arg : ::Int32 = 1), def foo1(), def foo2()]}",
                                               "{\"Reference\", [def object_id() : UInt64, def ==(other : self), def ==(other), def same?(other : Reference) : Bool, def same?(other : Nil), def dup(), def hash(hasher), def inspect(io : IO) : Nil, def pretty_print(pp) : Nil, def to_s(io : IO) : Nil, def exec_recursive(method), def exec_recursive_clone(), def initialize()]}",
                                               "{\"Object\", [def ==(other), def !=(other), def !~(other), def ===(other), def =~(other), def hash(hasher), def hash(), def to_s(io : IO) : Nil, def to_s() : String, def inspect(io : IO) : Nil, def inspect() : String, def pretty_print(pp : PrettyPrint) : Nil, def pretty_inspect(width = 79, newline = \"\\n\", indent = 0) : String, def tap(), def try(), def in?(collection : Object) : Bool, def in?(*) : Bool, def not_nil!(message), def not_nil!(), def itself(), def dup(), def unsafe_as(type : T.class), def class(), def crystal_type_id() : Int32, def methods(), def all_methods(include_module : Bool = true) : Hash(String, Array(Crystal::Meta::AbstractMethod)), def instance_vars() : Array(String), def superclass() : Class, def superclasses() : Array(String)]}",
                                               "{\"Spec::ObjectExtensions\", [def should(expectation : BeAExpectation(T), failure_message : String | ::Nil, *, file = __FILE__, line = __LINE__) : T, def should(expectation, failure_message : String | ::Nil, *, file = __FILE__, line = __LINE__), def should_not(expectation : BeAExpectation(T), failure_message : String | ::Nil, *, file = __FILE__, line = __LINE__), def should_not(expectation : BeNilExpectation, failure_message : String | ::Nil, *, file = __FILE__, line = __LINE__), def should_not(expectation, failure_message : String | ::Nil, *, file = __FILE__, line = __LINE__)]}",
                                               "{\"Colorize::ObjectExtensions\", [def colorize(r : UInt8, g : UInt8, b : UInt8), def colorize(fore : UInt8), def colorize(fore : Symbol), def colorize(fore : Color), def colorize() : Colorize::Object]}"]
  end

  it "should return all instance methods defined on a class" do
    Foo.methods.map(&.to_s).should eq ["def initialize(arg : ::Int32 = 1)", "def foo1()", "def foo2()"]
    String.methods.map(&.to_s).select { |x| x.starts_with?("def unsafe_") }.should eq ["def unsafe_byte_at(index : Int) : UInt8",
                                                                                       "def unsafe_byte_slice(byte_offset, count) : Slice",
                                                                                       "def unsafe_byte_slice(byte_offset) : Slice",
                                                                                       "def unsafe_byte_slice_string(byte_offset, count, size = 0)",
                                                                                       "def unsafe_byte_slice_string(byte_offset, *, size = 0)"]
  end
end

module M
  def m1
  end

  def m2
  end
end

class Foo
  A = 1

  def initialize(@arg = 1)
  end

  def foo1
  end

  def foo2
  end

  def self.cfoo
  end
end

class Bar < Foo
  include M

  def bar1
  end

  def bar2
  end

  def self.cbar
  end
end

class Baz < Foo
  def baz1
  end

  def baz2
  end

  def self.cbaz
  end
end

class End < Baz
  include M
end
