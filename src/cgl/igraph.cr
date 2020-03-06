module CGL
  module IGraph(V)
    abstract def each_vertex(& : V ->)
    abstract def each_adjacent(v : T, & : V ->)

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

    abstract def has_vertex?(v : V) : Bool
    abstract def has_edge?(u : V, v : V) : Bool
    abstract def has_edge?(edge : AnyEdge(V)) : Bool

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
