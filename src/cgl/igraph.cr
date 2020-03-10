module CGL
  module IGraph(V)
    # Yields each vertex of the graph.
    abstract def each_vertex(& : V ->)

    # Yields each vertex adjacent to *u* in the graph.
    #
    # ```
    # g = Graph(String).new(edges: [{"b", "a"}, {"a", "c"}])
    # g.each_adjacent("a") do |v|
    #   puts v
    # end
    # ```
    # Output:
    # ```
    # b
    # c
    # ```
    #
    # For directed graphs, adjacent vertices are found following outgoing
    # edges.
    #
    # ```
    # g = DiGraph(String).new(edges: [{"b", "a"}, {"a", "c"}])
    # g.each_adjacent("a") do |v|
    #   puts v
    # end
    # ```
    # Output:
    # ```
    # c
    # ```
    abstract def each_adjacent(u : V, & : V ->)

    # Yields each edges in the graph.
    abstract def each_edge(& : AnyEdge(V) ->)

    # Yields each edge incident to *u* in the graph.
    abstract def each_edge_from(u : V, & : AnyEdge(V) ->)

    # Returns an array of edges belonging to this graph.
    def edges : Array(AnyEdge(V))
      Array(AnyEdge(V)).new.tap { |ary|
        self.each_edge { |e| ary << e }
      }
    end

    # See `#edges`.
    def to_a : Array(AnyEdge(V))
      self.edges
    end

    # Add a single vertex (a.k.a. node) to this graph.
    #
    # ```
    # g = CGL::Graph(String).new
    # g.add_vertex("Hello")
    # ```
    abstract def add_vertex(v : V)

    # Remove given vertex *v* from this graph.
    # Edges incident to *v* are also removed.
    #
    # Raises a `GraphError` if vertex is not part of the graph.
    #
    # ```
    # g = CGL::Graph(String).new(edges: [{"a", "b"}, {"b", "c"}])
    # g.size # => 2
    # g.remove_vertex("b")
    # g.size # => 0
    # ```
    abstract def remove_vertex(v : V)

    # Add an edge between vertices *u* and *v*.
    #
    # The given vertices are automatically added if they are not already part
    # of the graph.
    #
    # A *weight* and/or a label can be associated to the edge if
    # the concrete class supports it.
    abstract def add_edge(u : V, v : V, weight, label)

    # Deletes the given edge and returns it, else yields *u* and *v* to the given block.
    abstract def remove_edge(u : V, v : V)

    # Deletes the given edge and returns it, otherwise returns `nil`.
    def remove_edge(u : V, v : V)
      remove_edge(u, v) { nil }
    end

    # Returns the number of edges in `self`.
    abstract def size : Int32

    # Returns the number of vertices in `self`.
    abstract def order : Int32

    # Whether the graph is empty.
    def empty? : Bool
      self.size == 0
    end

    # Returns an edge data structure between *u* and *v* if present in the
    # graph, otherwise returns the value of the given block.
    def edge(u : V, v : V)
      if has_edge?(u, v)
        unchecked_edge(u, v)
      else
        yield
      end
    end

    # Returns the weight associated with the given edge if it exists, otherwise
    # returns `nil`.
    abstract def weight_of(u : V, v : V)

    # Returns the label associated with the given edge if it exists, otherwise
    # returns `nil`.
    abstract def label_of(u : V, v : V)

    # Returns an edge data structure between *u* and *v* if present in the
    # graph, otherwise returns `nil`.
    def edge?(u : V, v : V)
      edge(u, v) { nil }
    end

    # Returns an edge data structure between *u* and *v* if present in the
    # graph, otherwise raises an `EdgeError`.
    def edge(u : V, v : V)
      edge(u, v) { EdgeError.new("No edge between #{u} and #{v} found") }
    end

    # Returns an edge data structure between *u* and *v* without checking
    # if present in the graph.
    protected abstract def unchecked_edge(u : V, v : V)

    # Whether the given vertex *v* is part of the graph.
    abstract def has_vertex?(v : V) : Bool

    # Whether the edge between *u* and *v* with the given attributes
    # is part of the graph.
    abstract def has_edge?(u : V, v : V, weight, label) : Bool

    # Whether the edge between *u* and *v* is part of the graph.
    abstract def has_edge?(u : V, v : V) : Bool

    # Whether the given edge is part of the graph.
    def has_edge?(edge : Labelable(V, L)) : Bool forall L
      has_edge?(edge.u, edge.v, self.default_weight, edge.label)
    end

    # ditto
    def has_edge?(edge : Weightable(V, W)) : Bool forall W
      has_edge?(edge.u, edge.v, edge.weight, self.default_label)
    end

    # ditto
    def has_edge?(edge : AnyEdge(V)) : Bool
      has_edge?(edge.u, edge.v)
    end

    # Returns the degree of the given vertex *v*.
    #
    # For directed graphs, the value equals `#out_degree_of`.
    #
    # For undirected graphs, the value is the sum of `#in_degree_of` and
    # `#in_degree_of`.
    abstract def degree_of(v : V) : Int32

    # Returns the incoming degree of the given vertex *v*.
    #
    # For undirected graphs, the value equals `#degree_of`.
    abstract def in_degree_of(v : V) : Int32

    # Returns the outgoing degree of the given vertex *v*.
    #
    # For undirected graphs, the value equals `#degree_of`.
    abstract def out_degree_of(v : V) : Int32

    # Empties a `IGraph` and returns it.
    abstract def clear

    # Whether `self` is directed.
    abstract def directed? : Bool

    # Whether `self` is equal to *other*.
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

    # See `Object#hash(hasher)`
    def hash(hasher)
      # The hash value must be the same regardless of the
      # order of the edges.
      result = hasher.result

      each_edge do |edge|
        copy = hasher
        copy = edge.hash(copy)
        result &+= copy.result
      end

      result.hash(hasher)
    end
  end
end
