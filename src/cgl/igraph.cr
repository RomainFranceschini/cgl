module CGL
  module IGraph(V)
    abstract def each_vertex(& : V ->)
    abstract def each_adjacent(v : V, & : V ->)

    def edges
      Array(AnyEdge(V)).new.tap { |ary|
        self.each_edge { |e| ary << e }
      }
    end

    # Returns the number of edges in `self`.
    abstract def size : Int32

    # Returns the number of vertices in `self`.
    abstract def order : Int32

    def empty? : Bool
      self.size == 0
    end

    def edge(u : V, v : V)
      if has_edge?(u, v)
        unchecked_edge(u, v)
      else
        yield
      end
    end

    def edge?(u : V, v : V)
      edge(u, v) { nil }
    end

    def edge(u : V, v : V)
      edge(u, v) { EdgeError.new("No edge between #{u} and #{v} found") }
    end

    protected abstract def unchecked_edge(u : V, v : V)

    abstract def has_vertex?(v : V) : Bool
    abstract def has_edge?(u : V, v : V, weight : W, label : L) : Bool
    abstract def has_edge?(u : V, v : V) : Bool

    def has_edge?(edge : Labelable(V, L)) : Bool
      has_edge?(edge.u, edge.v, self.default_weight, edge.label)
    end

    def has_edge?(edge : Weightable(V, L)) : Bool
      has_edge?(edge.u, edge.v, edge.weight, self.default_label)
    end

    def has_edge?(edge : AnyEdge(V)) : Bool
      has_edge?(edge.u, edge.v)
    end

    abstract def degree_of(v : V) : Int32
    abstract def in_degree_of(v : V) : Int32
    abstract def out_degree_of(v : V) : Int32

    # Whether `self` is directed.
    abstract def directed? : Bool

    def ==(other : IGraph)
      return false if size != other.size || order != other.order
      each_vertex { |v|
        return false unless other.has_vertex?(v)
        each_edge_from(v) { |e|
          return false unless other.has_edge?(e)
        }
      }
      true
    end

    def ==(other)
      false
    end
  end
end
