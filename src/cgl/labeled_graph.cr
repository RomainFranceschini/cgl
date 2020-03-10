module CGL
  class LabeledGraph(V, L)
    include IGraph(V)
    include AdjacencyHash(V, Nil, L)

    # The block triggered for default labels.
    @block : (-> L)

    def initialize(vertices : Enumerable(V)? = nil, edges : Enumerable(Tuple(V, V))? = nil, labels : Enumerable(L)? = nil, &block : -> L)
      @block = block
      super(vertices, edges, labels: labels)
    end

    def initialize(vertices : Enumerable(V)? = nil, edges : Enumerable(Tuple(V, V))? = nil, labels : Enumerable(L)? = nil, *, default_label : L)
      @block = ->{ default_label }
      super(vertices, edges, labels: labels)
    end

    def default_label : L
      @block.call
    end

    def default_weight : Nil
      nil
    end

    def each_edge(& : AnyEdge(V) ->)
      visited = Set(AnyEdge(V)).new
      each_vertex do |u|
        each_adjacent(u) do |v|
          edge = LEdge(V, L).new(u, v, unsafe_fetch(u, v).last)
          if !visited.includes?(edge)
            visited << edge
            yield edge
          end
        end
      end
    end

    def each_edge_from(u : V, & : AnyEdge(V) ->)
      each_adjacent(u) { |v| yield LEdge(V, L).new(u, v, unsafe_fetch(u, v).last) }
    end
  end
end
