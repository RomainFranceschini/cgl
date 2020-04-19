module CGL
  # Reusable adjacency list representation for an `AnyGraph`.
  #
  # Uses a hash table to associate each vertex `V` with a set of adjacent
  # vertices. The set is backed by another hash table that can be used to store
  # arbitrary data of type `L` and a weight of type `W` with each edge.
  module AdjacencyHash(V, W, L)
    @vertices : Hash(V, Hash(V, {W, L?}))

    # The number of edges in `self`.
    getter size : Int32 = 0

    # The block triggered for default edge labels.
    getter label_block : (-> L?)

    # The default edge weight value.
    getter default_weight : W

    private def get_default_weight(default_weight) : W
      {% if W == Nil %}
        nil
      {% elsif !W.union? && (W < Number::Primitive) %}
        default_weight || 1
      {% else %}
        {{ raise "W should be a primitive number type or Nil for unweighted graphs, not #{W}." }}
      {% end %}
    end

    private def fill_graph(
      vertices : Enumerable(V)? = nil, edges : Enumerable(Tuple(V, V))? = nil,
      weights : Enumerable(W)? = nil, labels : Enumerable(L?)? = nil
    )
      vertices.try &.each { |v| add_vertex(v) }
      edges.try &.each_with_index do |tuple, i|
        add_edge(
          tuple.first,
          tuple.last,
          weights.try(&.[i]) || self.default_weight,
          labels.try(&.[i]) || self.default_label
        )
      end
    end

    def initialize(
      vertices : Enumerable(V)? = nil, edges : Enumerable(Tuple(V, V))? = nil,
      weights : Enumerable(W)? = nil, labels : Enumerable(L?)? = nil,
      *, default_weight : W? = nil, &block : -> L?
    )
      @default_weight = get_default_weight(default_weight)
      @vertices = Hash(V, Hash(V, {W, L?})).new(vertices.try &.size) { |h, k|
        h[k] = Hash(V, {W, L?}).new
      }
      @label_block = block
      fill_graph(vertices, edges, weights, labels)
    end

    def initialize(
      vertices : Enumerable(V)? = nil, edges : Enumerable(Tuple(V, V))? = nil,
      weights : Enumerable(W)? = nil, labels : Enumerable(L?)? = nil,
      *, default_weight : W? = nil, default_label : L? = nil
    )
      @default_weight = get_default_weight(default_weight)
      @vertices = Hash(V, Hash(V, {W, L?})).new(vertices.try &.size) { |h, k|
        h[k] = Hash(V, {W, L?}).new
      }
      @label_block = Proc(L?).new { default_weight }
      fill_graph(vertices, edges, weights, labels)
    end

    def initialize(edges : Enumerable(AnyEdge(V)), *, default_weight : W? = nil, &block : -> L?)
      @default_weight = get_default_weight(default_weight)
      @vertices = Hash(V, Hash(V, {W, L?})).new { |h, k|
        h[k] = Hash(V, {W, L?}).new
      }
      @label_block = block
      edges.each { |edge| add_edge(edge) }
    end

    def initialize(edges : Enumerable(AnyEdge(V)), *, default_weight : W? = nil, default_label : L? = nil)
      @default_weight = get_default_weight(default_weight)
      @vertices = Hash(V, Hash(V, {W, L?})).new { |h, k|
        h[k] = Hash(V, {W, L?}).new
      }
      @label_block = Proc(L?).new { default_label }
      edges.each { |edge| add_edge(edge) }
    end

    def add_edge(edge : AnyEdge(V))
      weight = edge.is_a?(Weightable(W)) ? edge.weight : default_weight
      label = edge.is_a?(Labelable(L)) ? edge.label : default_label
      add_edge(edge.u, edge.v, weight, label)
    end

    # Returns the default weight associated with an edge.
    protected def default_weight : W
      @default_weight
    end

    # Returns the default label associated with an edge.
    protected def default_label : L?
      @label_block.call
    end

    def clear
      @vertices.clear
      @size = 0
      self
    end

    def add_vertex(v : V)
      @vertices[v]
    end

    def has_edge?(u : V, v : V) : Bool
      has_vertex?(u) && @vertices[u].has_key?(v)
    end

    def has_edge?(u : V, v : V, weight : W, label : L?) : Bool
      has_edge?(u, v) && unsafe_fetch(u, v) == {weight, label}
    end

    protected def unsafe_fetch(u : V, v : V) : {W, L?}
      @vertices[u][v]
    end

    def weight_of(u : V, v : V) : W
      return nil unless has_edge?(u, v)
      unsafe_fetch(u, v).first
    end

    def label_of(u : V, v : V) : L?
      return nil unless has_edge?(u, v)
      unsafe_fetch(u, v).last
    end

    def order : Int32
      @vertices.size
    end

    def each_vertex(& : V ->)
      @vertices.each_key { |v| yield v }
    end

    def each_vertex : Iterator(V)
      @vertices.each_key
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

    def each_adjacent(u : V) : Iterator(V)
      if has_vertex?(u)
        @vertices[u].each_key
      else
        raise GraphError.new("vertex #{u} is not part of this graph")
      end
    end

    protected def unchecked_edge(u, v)
      if directed?
        {% if W != Nil && L == Nil %}
          WDiEdge(V, W).new(u, v, unsafe_fetch(u, v).first)
        {% elsif W == Nil && L != Nil %}
          LDiEdge(V, L).new(u, v, unsafe_fetch(u, v).last)
        {% else %}
          DiEdge(V).new(u, v) # TODO LWEdge
        {% end %}
      else
        {% if W != Nil && L == Nil %}
          WEdge(V, W).new(u, v, unsafe_fetch(u, v).first)
        {% elsif W == Nil && L != Nil %}
          LEdge(V, L).new(u, v, unsafe_fetch(u, v).last)
        {% else %}
          Edge(V).new(u, v) # TODO LWEdge
        {% end %}
      end
    end
  end

  # A base class for adjacency list-based *undirected* graphs
  abstract class AdjacencyGraph(V, W, L) < AbstractGraph(V)
    include AdjacencyHash(V, W, L)

    def add_edge(u : V, v : V, weight : W = self.default_weight, label : L? = self.default_label)
      unless has_edge?(u, v)
        @size += 1
        @vertices[u][v] = {weight, label}
        @vertices[v][u] = {weight, label}
      end
    end

    def remove_edge(u : V, v : V)
      if edge = edge?(u, v)
        @vertices[u].delete(v)
        @vertices[v].delete(u)
        @size -= 1
        edge
      else
        yield(u, v)
      end
    end

    def remove_vertex(v : V)
      if has_vertex?(v)
        @size -= @vertices[v].size
        each_adjacent(v) { |u| @vertices[u].delete(v) } # remove all edges v-u
        @vertices.delete(v)                             # remove vertex v
      else
        raise GraphError.new("The vertex #{v} is not in the graph.")
      end
    end

    def degree_of(v : V) : Int32
      return 0 unless has_vertex?(v)
      adj = @vertices[v]
      size = adj.size
      size += 1 if adj.has_key?(v) # self loop
      size
    end
  end

  # A base class for adjacency list-based *directed* graphs
  abstract class AdjacencyDiGraph(V, W, L) < AbstractDiGraph(V)
    include AdjacencyHash(V, W, L)

    def add_edge(u : V, v : V, weight : W = self.default_weight, label : L? = self.default_label)
      adj = @vertices[u]
      if !adj.has_key?(v)
        add_vertex(v)
        @size += 1
        adj[v] = {weight, label}
      end
    end

    def remove_edge(u : V, v : V)
      if edge = edge?(u, v)
        @vertices[u].delete(v)
        @size -= 1
        edge
      else
        yield(u, v)
      end
    end

    def remove_vertex(v : V)
      if has_vertex?(v)
        @size -= @vertices[v].size
        @vertices.delete(v) # remove vertex v
        each_vertex do |u|  # search and remove edges incident to v
          if @vertices[u].has_key?(v)
            @vertices[u].delete(v)
            @size -= 1
          end
        end
      else
        raise GraphError.new("The vertex #{v} is not in the graph.")
      end
    end

    # Yields each predecessor of *u* in the graph.
    def each_predecessor(v : V, & : V ->)
      if has_vertex?(v)
        each_vertex { |u| yield(u) if @vertices[u].has_key?(v) }
      end
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
  end
end
