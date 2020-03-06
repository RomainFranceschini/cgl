module CGL
  # Reusable adjacency list representation for a `IGraph`.
  #
  # Uses a hash table to associate each vertex `V` with a set of adjacent
  # vertices. The set is backed by another hash table that can be used to store
  # data `L` with each edge.
  module AdjacencyHash(V, L)
    @vertices : Hash(V, Hash(V, L))

    # The number of edges in `self`.
    getter size : Int32 = 0

    def initialize(vertices : Array(V)? = nil, edges : Array(Tuple(V, V))? = nil, labels : Array(L)? = nil)
      @vertices = Hash(V, Hash(V, L)).new(vertices.try &.size) { |h, k|
        h[k] = Hash(V, L).new
      }
      vertices.try &.each { |v| add_vertex(v) }
      if labels.nil?
        edges.try &.each { |u, v| add_edge(u, v) }
      else
        edges.try &.each_with_index do |tuple, i|
          add_edge(tuple.first, tuple.last, labels[i])
        end
      end
    end

    def add_vertex(v : V)
      @vertices[v]
    end

    def has_edge?(u : V, v : V) : Bool
      has_vertex?(u) && @vertices[u].has_key?(v)
    end

    def has_edge?(u : V, v : V, attr : L) : Bool
      has_edge?(u, v) && unsafe_fetch(u, v) == attr
    end

    # Returns the element assoiated with the given edge if it exists,
    # otherwise executes the given block and returns its value.
    protected def fetch(u : V, v : V)
      return yield unless has_edge?(u, v)
      unsafe_fetch(u, v)
    end

    protected def unsafe_fetch(u : V, v : V)
      @vertices[u][v]
    end

    def has_edge?(edge : AnyEdge(V)) : Bool
      has_edge?(edge.u, edge.v)
    end

    def has_edge?(edge : Labelable(V, L)) : Bool
      has_edge?(edge.u, edge.v, edge.label)
    end

    def has_edge?(edge : Weightable(V, L)) : Bool
      has_edge?(edge.u, edge.v, edge.weight)
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
      if has_vertex?(u)
        @vertices[u].each_key { |v| yield v }
      end
    end

    # :nodoc:
    module ClassMethods
      def default_edge_attr
        nil
      end
    end

    macro included
      extend ClassMethods

      {% if @type.name.includes?("DiGraph") %}

        def add_edge(u : V, v : V, attr = self.class.default_edge_attr)
          adj = @vertices[u]
          if !adj.has_key?(v)
            add_vertex(v)
            @size += u == v ? 2 : 1 # self loops counts 2 edges
            adj[v] = attr
          end
        end

        def degree_of(v : V) : Int32
          in_degree_of(v) + out_degree_of(v)
        end

        def in_degree_of(v : V) : Int32
          size = 0
          if has_vertex?(v)
            each_vertex { |u| size += 1 if @vertices[u].has_key?(v) }
          end
          size
        end

        def out_degree_of(v : V) : Int32
          return 0 unless has_vertex?(v)
          @vertices[v].size
        end

        def directed? : Bool
          true
        end
      {% else %}
        def add_edge(u : V, v : V, attr = self.class.default_edge_attr)
          unless has_edge?(u, v)
            @size += 1
            @vertices[u][v] = attr
            @vertices[v][u] = attr
          end
        end

        def degree_of(v : V) : Int32
          return 0 unless has_vertex?(v)
          adj = @vertices[v]
          size = adj.size
          size += 1 if adj.has_key?(v) # self loop
          size
        end

        def out_degree_of(v : V) : Int32
          degree_of(v)
        end

        def in_degree_of(v : V) : Int32
          degree_of(v)
        end

        def directed? : Bool
          false
        end
      {% end %}
    end
  end
end
