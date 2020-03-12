module CGL
  class MultiGraph(V, W, L)
    include IGraph(V)
    include AdjacencyHash(V, Array(W), Array(L))
  end
end
