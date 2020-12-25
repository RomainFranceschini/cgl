module CGL
  class AnyGraph(V)
    # Count all simple paths between the two given vertices,
    # where a simple path is a path with no repeated nodes.
    def count_simple_paths(source : V, target : V)
      count = 0
      queue = Deque(V){source}

      while (u = queue.shift?)
        count += 1 if u == target
        self.each_adjacent(u) { |v| queue.push(v) }
      end

      count
    end
  end
end
