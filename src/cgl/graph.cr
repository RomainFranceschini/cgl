module CGL
  class Graph(V) < AdjacencyGraph(V, Nil, Nil)
  end

  class LabeledGraph(V, L) < AdjacencyGraph(V, Nil, L)
  end

  class WeightedGraph(V, W) < AdjacencyGraph(V, W, Nil)
  end

  class WeightedLabeledGraph(V, W, L) < AdjacencyGraph(V, W, L)
  end
end
