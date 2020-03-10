module CGL
  # Reusable adjacency list representation for a `IGraph`.
  #
  # Uses a hash table to associate each vertex `V` with a set of adjacent
  # vertices. The set is backed by another hash table that can be used to store
  # data `L` with each edge.
  module AdjacencyHash(V, W, L)
    @vertices : Hash(V, Hash(V, {W, L}))

    # The number of edges in `self`.
    getter size : Int32 = 0

    def initialize(vertices : Enumerable(V)? = nil, edges : Enumerable(Tuple(V, V))? = nil, weights : Enumerable(W)? = nil, labels : Enumerable(L)? = nil)
      @vertices = Hash(V, Hash(V, {W, L})).new(vertices.try &.size) { |h, k|
        h[k] = Hash(V, {W, L}).new
      }
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

    # Returns the default weight associated with an edge.
    abstract def default_weight : W

    # Returns the default label associated with an edge.
    abstract def default_label : L

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

    def has_edge?(u : V, v : V, weight : W, label : L) : Bool
      has_edge?(u, v) && unsafe_fetch(u, v) == {weight, label}
    end

    protected def unsafe_fetch(u : V, v : V) : {W, L}
      @vertices[u][v]
    end

    def weight_of(u : V, v : V) : W
      return nil unless has_edge?(u, v)
      unsafe_fetch(u, v).first
    end

    def label_of(u : V, v : V) : L
      return nil unless has_edge?(u, v)
      unsafe_fetch(u, v).last
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

    macro included
      {% if @type.name.includes?("DiGraph") %}

        def add_edge(u : V, v : V, weight : W = self.default_weight, label : L = self.default_label)
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
            @vertices.delete(v)  # remove vertex v
            each_vertex do |u|   # search and remove edges incident to v
              if @vertices[u].has_key?(v)
                @vertices[u].delete(v)
                @size -= 1
              end
            end
          else
            raise GraphError.new("The vertex #{v} is not in the graph.")
          end
        end

        def each_edge(& : AnyEdge(V) ->)
          each_vertex do |u|
            each_adjacent(u) { |v| yield unchecked_edge(u, v) }
          end
        end

        def each_edge_from(u : V, & : AnyEdge(V) ->)
          each_adjacent(u) { |v| yield unchecked_edge(u, v) }
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

      {% else %}  # Undirected graph

        def add_edge(u : V, v : V, weight : W = self.default_weight, label : L = self.default_label)
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

        def each_edge(& : AnyEdge(V) ->)
          visited = Set(AnyEdge(V)).new
          each_vertex do |u|
            each_adjacent(u) do |v|
              edge = unchecked_edge(u, v)
              if !visited.includes?(edge)
                visited << edge
                yield edge
              end
            end
          end
        end

        def each_edge_from(u : V, & : AnyEdge(V) ->)
          each_adjacent(u) { |v| yield unchecked_edge(u, v) }
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
