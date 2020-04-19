module CGL
  class DiGraph(V) < AdjacencyDiGraph(V, Nil, Nil)
  end

  class LabeledDiGraph(V, L) < AdjacencyDiGraph(V, Nil, L)
  end

  class WeightedDiGraph(V, W) < AdjacencyDiGraph(V, W, Nil)
  end

  class WeightedLabeledDiGraph(V, W, L) < AdjacencyDiGraph(V, W, L)
  end
end
