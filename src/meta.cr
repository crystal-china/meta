module Crystal::Meta
  module AbstractType
  end

  struct Type(T)
    include AbstractType

    def initialize(@type : T)
    end

    def name
      @type.name
    end

    # def subclasses
    #   @type.subclasses
    # end

    def all_subclasses
      @type.all_subclasses
    end

    def to_s(io : IO)
      io << @type
    end

    def inspect(io : IO)
      to_s(io)
    end

    def ==(other : Type)
      @type == other.@type
    end

    def ==(other : Class)
      @type == other
    end
  end

  module AbstractMethod
  end

  struct Method
    include AbstractMethod

    getter name : String
    getter args : Array(Arg)
    getter splat_index : Int32?
    getter return_type : String?

    def initialize(
      @name : String,
      @args : Array(Arg),
      @splat_index : Int32?,
      @return_type : String?,
    )
    end

    def to_s(io : IO)
      splat_index = @splat_index

      io << "def "
      io << @name
      io << '('
      @args.each_with_index do |arg, i|
        io << ", " if i > 0

        if splat_index && i == splat_index
          io << "*"
        else
          io << arg
        end
      end
      io << ')'
      if return_type = @return_type
        io << " : "
        io << return_type
      end
    end

    def inspect(io : IO)
      to_s(io)
    end
  end

  struct Arg
    getter name : String
    getter restriction : String?

    def initialize(
      @name : String,
      @internal_name : String,
      @restriction : String?,
      @default_value : String?,
    )
    end

    def to_s(io : IO)
      io << @name
      if @internal_name != @name
        io << ' '
        io << @internal_name
      end
      if restriction = @restriction
        io << " : " << restriction
      end
      if default_value = @default_value
        io << " = " << default_value
      end
    end
  end
end

class Class
  def subclasses
    {% begin %}
      [
        {% for type in @type.subclasses %}
          Crystal::Meta::Type.new({{type.name(generic_args: false)}}),
        {% end %}
      ] of Crystal::Meta::AbstractType
    {% end %}
  end

  def includers
    {% if @type.includers.size > 0 %}
      {{ @type.includers.map &.stringify }}
    {% else %}
      {{ [""] }}
    {% end %}
  end

  def constants
    {% if @type.constants.size > 0 %}
      {{ @type.constants.map &.stringify }}
    {% else %}
      {{ [""] }}
    {% end %}
  end

  def ancestors
    {% if @type.ancestors.size > 0 %}
      {{ @type.ancestors.map &.stringify }}
    {% else %}
      {{ [""] }}
    {% end %}
  end

  def all_subclasses
    all_subclasses = [] of Crystal::Meta::AbstractType

    subclasses.each do |subclass|
      all_subclasses << subclass
      all_subclasses.concat(subclass.all_subclasses)
    end

    all_subclasses
  end

  def methods
    {% begin %}
      [
        {% for method in @type.methods %}
          Crystal::Meta::Method.new(
          name: {{method.name.stringify}},
          args: [
            {% for arg in method.args %}
              Crystal::Meta::Arg.new(
              name: {{arg.name.stringify}},
              internal_name: {{arg.internal_name.stringify}},
              restriction: {{arg.restriction ? arg.restriction.stringify : "nil".id}},
              default_value: {{arg.default_value ? arg.default_value.stringify : "nil".id}},
            ),
            {% end %}
          ] of Crystal::Meta::Arg,
               splat_index: {{method.splat_index}},
               return_type: {{method.return_type ? method.return_type.stringify : "nil".id}},
        ),
        {% end %}
      ] of Crystal::Meta::AbstractMethod
    {% end %}
  end

  def class_methods
    {% begin %}
      [
        {% for method in @type.class.methods %}
          Crystal::Meta::Method.new(
          name: {{method.name.stringify}},
          args: [
            {% for arg in method.args %}
              Crystal::Meta::Arg.new(
              name: {{arg.name.stringify}},
              internal_name: {{arg.internal_name.stringify}},
              restriction: {{arg.restriction ? arg.restriction.stringify : "nil".id}},
              default_value: {{arg.default_value ? arg.default_value.stringify : "nil".id}},
            ),
            {% end %}
          ] of Crystal::Meta::Arg,
               splat_index: {{method.splat_index}},
               return_type: {{method.return_type ? method.return_type.stringify : "nil".id}},
        ),
        {% end %}
      ] of Crystal::Meta::AbstractMethod
    {% end %}
  end
end

class Object
  def methods
    {{@type}}.methods
  end

  def all_methods(include_module : Bool = true) : Hash(String, Array(Crystal::Meta::AbstractMethod))
    a = {self.class.to_s => methods}

    if include_module
      {% for m in @type.ancestors %}
        {% if ["Comparable(Tuple(*T))", "Comparable(Array(T))", "Comparable(Enum)"].includes? m.stringify %}
          a[{{ m.stringify }}] = Comparable.methods
        {% else %}
          a[{{ m.stringify }}] = {{ m }}.methods
        {% end %}
      {% end %}
    else
      superklass = self.superclass

      until superklass == Object
        a[superklass.to_s] = superklass.methods

        superklass = superklass.superclass
      end
    end

    a["Object"] = Object.methods

    a
  end

  def instance_vars : Array(String)
    a = [] of String

    {% for ivar in @type.instance_vars %}
      a.push("@" + {{ivar.stringify}})
    {% end %}

    a
  end

  def superclass : Class
    {% if @type.superclass.nil? %}
      Object
    {% else %}
      {{ @type.superclass }}
    {% end %}
  end

  def superclasses : Array(String)
    a = [] of String

    superklass = self.superclass

    until superklass == Object
      a << superklass.to_s
      superklass = superklass.superclass
    end

    a << "Object"
  end
end

def methods
  {% begin %}
    [
      {% for method in @top_level.methods %}
        Crystal::Meta::Method.new(
        name: {{method.name.stringify}},
        args: [
          {% for arg in method.args %}
            Crystal::Meta::Arg.new(
            name: {{arg.name.stringify}},
            internal_name: {{arg.internal_name.stringify}},
            restriction: {{arg.restriction ? arg.restriction.stringify : "nil".id}},
            default_value: {{arg.default_value ? arg.default_value.stringify : "nil".id}},
          ),
          {% end %}
        ] of Crystal::Meta::Arg,
             splat_index: {{method.splat_index}},
             return_type: {{method.return_type ? method.return_type.stringify : "nil".id}},
      ),
      {% end %}
    ] of Crystal::Meta::AbstractMethod
  {% end %}
end

def pc(e)
  pp!(e, e.class, typeof(e))
end
