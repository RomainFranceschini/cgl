module CGL
  class Graph(V)
    include IGraph(V)
    include AdjacencyHash(V, Nil, Nil)

    def default_weight : Nil
      nil
    end

    def default_label : Nil
      nil
    end

    protected def unchecked_edge(u, v)
      Edge(V).new(u, v)
    end
  end
end
