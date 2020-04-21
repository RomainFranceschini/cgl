module CGL
  class AnyGraph(V)
    # Returns a shortest path between the given vertices.
    #
    # Note: Tries to select the most appropriate algorithm for `self`.
    def shortest_path(source : V, target : V)
      unless has_vertex?(source) && has_vertex?(target)
        raise GraphError.new("Vertices #{source} and/or #{target} are not in the graph")
      end

      if weighted?
        shortest_path_dijkstra(source, target)
      else
        shortest_path_unweighted(source, target)
      end
    end

    # Returns the shortest *unweighted* path between the given vertices.
    def shortest_path_unweighted(source : V, target : V)
      pred = Hash(V, V).new
      queue = Deque(V){source}
      pred[source] = source
      found = source == target

      while (u = queue.shift?)
        if u == target
          found = true
          break
        end

        self.each_adjacent(u) do |v|
          unless pred.has_key?(v)
            queue.push(v)
            pred[v] = u
          end
        end
      end

      if found
        build_shortest_path_from_predecessors(source, target, pred)
      else
        raise GraphError.new("No path between #{source} and #{target} found in graph")
      end
    end

    private def build_shortest_path_from_predecessors(a : V, b : V, pred : Hash(V, V))
      path = [b]
      current = b
      while current != a
        current = pred[current]
        path.push(current)
      end
      path.reverse!
      path
    end

    # Returns the shortest *weighted* path between the given vertices.
    #
    # Raises if `self` is not a weighted graph.
    #
    # Note: Uses Dijkstra's algorithm. Not appropriate for graphs
    # with negative weights and/or negative cycles.
    def shortest_path_dijkstra(source : V, target : V)
      unless weighted?
        raise GraphError.new("a weighted graph is required for this operation")
      end

      unless has_vertex?(source) && has_vertex?(target)
        raise GraphError.new("Vertices #{source} and/or #{target} are not in the graph")
      end

      found = source == target

      heap = BinaryHeap(V).new
      dist = Hash(V, Float64).new(Float64::INFINITY)
      pred = Hash(V, V).new
      dist[source] = 0.0
      pred[source] = source
      heap.push(Float64::INFINITY, source)

      while !heap.empty?
        u = heap.pop

        if u == target
          found = true
          break
        end

        self.each_adjacent(u) do |v|
          cost = dist[u] + weight_of(u, v).not_nil!

          if cost < dist[u]
            raise GraphError.new("Found negative weights along the path." \
                                 "Dijkstra's algorithm is not appropriate")
          end

          if cost < dist[v]
            dist[v] = cost
            pred[v] = u

            if heap.includes?(v)
              heap.adjust(v, cost)
            else
              heap.push(cost, v)
            end
          end
        end
      end

      if found
        build_shortest_path_from_predecessors(source, target, pred)
      else
        raise GraphError.new("No path between #{source} and #{target} found in graph")
      end
    end
  end
end
