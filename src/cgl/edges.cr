module CGL
  module AnyEdge(V)
    property u : V
    property v : V

    def initialize(@u : V, @v : V)
    end

    def to_tuple
      {@u, @v}
    end

    def clone
      self.class.new(@u.clone, @v.clone)
    end
  end

  module Undirected(V)
    include AnyEdge(V)

    def ==(other : AnyEdge)
      (@u == other.u && @v == other.v) || (@v == other.u && @u == other.v)
    end

    # See `Object#hash(hasher)`
    def hash(hasher)
      # The hash value must be the same regardless of the
      # order of the vertices.
      result = hasher.result

      {@u, @v}.each do |v|
        copy = hasher
        copy = v.hash(copy)
        result &+= copy.result
      end

      result.hash(hasher)
    end
  end

  module Directed(V)
    include AnyEdge(V)

    def ==(other : AnyEdge)
      (@u == other.u && @v == other.v)
    end

    def reverse
      {{@type}}.new(@v, @u)
    end

    def_hash @u, @v
  end

  module Labelable(L)
    property label : L?

    def initialize(@u, @v, @label)
    end

    def to_tuple
      {@u, @v, @label}
    end

    def hash(hasher)
      hasher = super
      @label.hash(hasher)
    end

    def ==(other : Labelable)
      super && @label == other.label
    end

    def clone
      self.class.new(@u.clone, @v.clone, @label.clone)
    end
  end

  module Weightable(T)
    property weight : T

    def initialize(@u, @v, @weight)
      {% if !T.union? && (T < Number::Primitive) %}
        # Support number types
      {% else %}
        {{ raise "Can only create weighted edges with primitive number types. Use a labeled edge for #{T}" }}
      {% end %}
    end

    def to_tuple
      {@u, @v, @weight}
    end

    def hash(hasher)
      hasher = super
      @weight.hash(hasher)
    end

    def ==(other : Weightable)
      super && @weight == other.weight
    end

    def clone
      self.class.new(@u.clone, @v.clone, @weight.clone)
    end
  end

  struct Edge(V)
    include Undirected(V)
  end

  struct WEdge(V, W)
    include Undirected(V)
    include Weightable(W)
  end

  struct LEdge(V, L)
    include Undirected(V)
    include Labelable(L)
  end

  struct DiEdge(V)
    include Directed(V)
  end

  struct WDiEdge(V, W)
    include Directed(V)
    include Weightable(W)
  end

  struct LDiEdge(V, L)
    include Directed(V)
    include Labelable(L)
  end
end
