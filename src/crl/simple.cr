module CRL
  class SimpleGraph(V)
    include Graph(V)

    @vertices : Hash(V, Set(V)) = Hash(V, Set(V)).new do |h, k|
      h[k] = Set(V).new
    end

    # The number of edges in `self`.
    getter size : Int32 = 0

    def initialize
    end

    def initialize(edges : Array(Tuple(V, V)))
      edges.each do |u, v|
        @size += 1
        @vertices[u] << v
        @vertices[v] << u
      end
    end

    def initialize(vertices : Array(V))
      vertices.each { |v| @vertices[v] }
    end

    def order : Int32
      @vertices.size
    end

    def each_vertex(& : V ->)
      @vertices.each_key { |v| yield v }
    end

    def vertices
      @vertices.keys
    end

    def has_vertex?(v : V) : Bool
      @vertices.has_key?(v)
    end

    def each_adjacent(u : V, & : V ->)
      @vertices[u].each { |v| yield v }
    end

    def degree_of(v : V) : Int32
      @vertices[v].size
    end

    def directed? : Bool
      false
    end
  end
end
