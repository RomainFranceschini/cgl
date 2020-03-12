module CGL
  class DiGraph(V)
    include IGraph(V)
    include AdjacencyHash(V, Nil, Nil)
  end

  class LabeledDiGraph(V, L)
    include IGraph(V)
    include AdjacencyHash(V, Nil, L)
  end

  class WeightedDiGraph(V, W)
    include IGraph(V)
    include AdjacencyHash(V, W, Nil)
  end

  class WeightedLabeledDiGraph(V, W, L)
    include IGraph(V)
    include AdjacencyHash(V, W, L)
  end
end
