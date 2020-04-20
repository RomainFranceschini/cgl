require "./iterators"

module CGL
  # A `BFSIterator` can be used to traverse a graph from a given vertex `V` in
  # a Breadth-first search fashion.
  class BFSIterator(V) < GraphSourceIterator(V)
    protected def next_vertex : V
      @deque.shift
    end
  end

  class AnyGraph(V)
    # Returns an iterator over vertices from the given source *v* in a
    # **breadth**-first search (DFS).
    def breadth_first_search(from vertex : V) : Iterator(V)
      BFSIterator(V).new(self, vertex)
    end

    # Yields vertices from the given source *v* in a
    # **breadth**-first search (DFS).
    def breadth_first_search(from vertex : V)
      queue = Deque(V){vertex}
      visited = Set(V){vertex}

      while (u = queue.shift?)
        self.each_adjacent(u) do |v|
          unless visited.includes?(v)
            visited.add(v)
            queue.push(v)
          end
        end
        yield(u)
      end
    end
  end
end
