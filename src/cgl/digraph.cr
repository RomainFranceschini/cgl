module CGL
  class DiGraph(V)
    include IGraph(V)
    include AdjacencyHash(V, Nil)

    def each_edge(& : AnyEdge(V) ->)
      each_vertex do |u|
        each_adjacent(u) { |v| yield DiEdge(V).new(u, v) }
      end
    end

    def each_edge_from(u : V, & : AnyEdge(V) ->)
      each_adjacent(u) { |v| yield DiEdge(V).new(u, v) }
    end
  end
end