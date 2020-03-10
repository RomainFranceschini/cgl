module CGL
  class Graph(V)
    include IGraph(V)
    include AdjacencyHash(V, Nil, Nil)

    def default_weight : Nil
      nil
    end

    def default_label : Nil
      nil
    end

    def each_edge(& : AnyEdge(V) ->)
      visited = Set(AnyEdge(V)).new
      each_vertex do |u|
        each_adjacent(u) do |v|
          edge = Edge(V).new(u, v)
          if !visited.includes?(edge)
            visited << edge
            yield edge
          end
        end
      end
    end

    def each_edge_from(u : V, & : AnyEdge(V) ->)
      each_adjacent(u) { |v| yield Edge(V).new(u, v) }
    end
  end
end
