require "./iterators"

module CGL
  # A `DFSIterator` can be used to traverse a graph from a given vertex `V` in
  # a Depth-first search fashion.
  class DFSIterator(V) < GraphIterator(V)
    protected def next_vertex : V
      @deque.pop
    end
  end

  class AnyGraph(V)
    # Returns an iterator over vertices from the given source *v* in a
    # **depth**-first search (DFS).
    def depth_first_search(from vertex : V) : Iterator(V)
      DFSIterator(V).new(self, vertex)
    end

    # Yields vertices from the given source *v* in a
    # **depth**-first search (DFS).
    def depth_first_search(from vertex : V)
      colors = Hash(V, Color).new(Color::White).tap { |h|
        h[vertex] = Color::Gray
      }
      depth_first_search(vertex, colors: colors) { |v| yield(v) }
    end

    def depth_first_search(vertex : V, *, colors : Hash(V, Color))
      stack = Deque(V).new
      stack.push(vertex) unless colors[vertex].black?

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

    # Yields all vertices of `self`, which are traversed following a
    # depth-first search (DFS) on the whole graph.
    def depth_first_search
      colors = Hash(V, Color).new(Color::White, self.order)
      each_vertex do |root|
        depth_first_search(root, colors: colors) { |v| yield(v) }
      end
    end

    # Returns an iterator over all vertices of `self`, which are traversed
    # following a depth-first search (DFS) on the whole graph.
    def depth_first_search : Iterator(V)
      colors = Hash(V, Color).new(Color::White, self.order)
      iterators = self.each_vertex.map do |vroot|
        DFSIterator(V).new(self, vroot, colors: colors)
      end
      Iterator(V).chain(iterators)
    end
  end
end
