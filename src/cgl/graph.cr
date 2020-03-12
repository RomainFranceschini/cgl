module CGL
  class Graph(V)
    include IGraph(V)
    include AdjacencyHash(V, Nil, Nil)
  end

  class LabeledGraph(V, L)
    include IGraph(V)
    include AdjacencyHash(V, Nil, L)
  end

  class WeightedGraph(V, W)
    include IGraph(V)
    include AdjacencyHash(V, W, Nil)
  end

  class WeightedLabeledGraph(V, W, L)
    include IGraph(V)
    include AdjacencyHash(V, W, L)
  end
end
