module CRL
  module AnyEdge(V)
    property u : V
    property v : V

    def initialize(@u, @v)
    end

    def to_tuple
      {@u, @v}
    end
  end

  module Undirected(V)
    include AnyEdge(V)

    def ==(other : Edge)
      (@u == other.u && @v == other.v) || (@v == other.u && @u == other.v)
    end
  end

  module Directed(V)
    include AnyEdge(V)

    def ==(other : Edge)
      (@u == other.u && @v == other.v)
    end

    def reverse
      {{@type}}.new(@v, @u)
    end
  end

  module Labelable(L)
    property label : L

    def initialize(@u, @v, @label)
    end

    def to_tuple
      {@u, @v, @label}
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

    def <=>(other : Weightable)
      @weight <=> other.weight
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
