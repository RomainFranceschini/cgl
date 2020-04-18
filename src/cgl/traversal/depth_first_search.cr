module CGL::IGraph(V)
  # Returns an iterator over vertices from the given source *v* in a
  # **depth**-first search (DFS).
  def depth_first_search(from vertex : V) : Iterator(V)
    DFSIterator(V).new(self, vertex)
  end

  # Yields vertices from the given source *v* in a
  # **depth**-first search (DFS).
  def depth_first_search(from vertex : V)
    stack = Deque(V){vertex}
    colors = Hash(V, Color).new(Color::White, self.order)
    colors[vertex] = Color::Gray

    while (u = stack.pop?)
      self.each_adjacent(u) do |v|
        if colors[v].white?
          colors[v] = Color::Gray
          stack.push(v)
        end
      end
      colors[u] = Color::Black
      yield(u)
    end
  end
end
