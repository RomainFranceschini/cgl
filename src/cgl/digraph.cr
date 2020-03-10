module CGL
  class DiGraph(V)
    include IGraph(V)
    include AdjacencyHash(V, Nil, Nil)

    def default_weight : Nil
      nil
    end

    def default_label : Nil
      nil
    end

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
