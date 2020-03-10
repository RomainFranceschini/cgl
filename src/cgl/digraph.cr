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

    protected def unchecked_edge(u : V, v : V)
      DiEdge(V).new(u, v)
    end
  end
end
