module CGL::IGraph(V)
  # Returns an iterator over vertices from the given source *v* in a
  # **depth**-first search (DFS).
  def depth_first_search(from vertex : V) : Iterator(V)
    DFSIterator(V).new(self, vertex)
  end
end
