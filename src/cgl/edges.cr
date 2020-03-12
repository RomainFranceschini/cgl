module CGL
  module AnyEdge(V)
    property u : V
    property v : V

    def initialize(@u, @v)
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

    def ==(other : Undirected | Directed)
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

    def ==(other : Undirected | Directed)
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

  class EdgeIterator(V)
    include Iterator(AnyEdge(V))

    @graph : IGraph(V)
    @vertices_it : Iterator(V)
    @adj_it : Iterator(V)? = nil
    @u : V? = nil
    @visited : Set(AnyEdge(V)) = Set(AnyEdge(V)).new

    def initialize(@graph)
      @vertices_it = @graph.each_vertex
    end

    def next
      loop do
        if u = next_u
          if v = get_v(u)
            edge = @graph.edge(u, v)
            if @graph.directed?
              return edge
            else
              if !@visited.includes?(edge)
                @visited << edge
                return edge
              end
            end
          else
            @u = nil
            @adj_it = nil
          end
        else
          return stop
        end
      end
    end

    private def next_u
      if vertex = @u
        vertex
      else
        value = @vertices_it.next
        return nil if value.is_a?(Stop)
        @u = value
        value
      end
    end

    private def get_v(u)
      @adj_it = @graph.each_adjacent(u) if @adj_it.nil?

      if iterator = @adj_it
        value = iterator.next
        return nil if value.is_a?(Stop)
        value
      end
    end
  end
end
