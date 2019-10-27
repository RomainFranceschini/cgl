module CRL
  VERSION = "0.1.0"

  module Graph(V)
    abstract def each_vertex(& : V ->)
    abstract def each_adjacent(v : T, & : V ->)

    def each_edge(& : AnyEdge(V) ->)
      if directed?
        each_vertex do |u|
          each_adjacent(u) { |v| yield DiEdge(V).new(u, v) }
        end
      else
        visited = Set(Edge(V)).new
        each_vertex do |u|
          each_adjacent(u) do |v|
            edge = Edge(V).new(u, v)
            if !visited.includes?(edge)
              visited << edge
              yield edge
            end
          end
        end
      end
    end

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

    abstract def degree_of(v : V) : Int32

    # Whether `self` is directed.
    abstract def directed? : Bool
  end
end

require "./crl/**"
