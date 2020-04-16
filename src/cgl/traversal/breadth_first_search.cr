module CGL::IGraph(V)
  # Returns an iterator over vertices from the given source *v* in a
  # **breadth**-first search (DFS).
  def breadth_first_search(from vertex : V) : Iterator(V)
    BFSIterator(V).new(self, vertex)
  end
end
