module CGL
  enum Color
    White
    Gray
    Black
  end

  abstract class GraphIterator(V)
    include Iterator(V)

    @graph : IGraph(V)
    @deque : Deque(V)
    @colors : Hash(V, Color)

    def initialize(@graph : IGraph(V), start : V, *, colors : Hash(V, Color)? = nil)
      unless @graph.has_vertex?(start)
        raise GraphError.new("#{start} is not a vertex from graph #{@graph}")
      end

      @deque = Deque(V).new
      @colors = colors || Hash(V, Color).new(Color::White).tap { |h|
        h[start] = Color::Gray
      }
      @deque.push(start) unless @colors[start].black?
    end

    def has_next?
      !@deque.empty?
    end

    protected abstract def next_vertex : V

    def next
      if has_next?
        u = next_vertex
        @graph.each_adjacent(u) do |v|
          if @colors[v].white?
            @colors[v] = Color::Gray
            @deque.push(v)
          end
        end
        @colors[u] = Color::Black
        u
      else
        stop
      end
    end
  end

  class EdgeIterator(V)
    include Iterator(AnyEdge(V))

    @graph : IGraph(V)
    @vertices_it : Iterator(V)
    @adj_it : Iterator(V)? = nil
    @u : V? = nil
    @visited : Set(AnyEdge(V)) = Set(AnyEdge(V)).new

    def initialize(@graph)
      @vertices_it = @graph.each_vertex
    end

    def next
      loop do
        if u = next_u
          if v = get_v(u)
            edge = @graph.edge(u, v)
            if @graph.directed?
              return edge
            else
              if !@visited.includes?(edge)
                @visited << edge
                return edge
              end
            end
          else
            @u = nil
            @adj_it = nil
          end
        else
          return stop
        end
      end
    end

    private def next_u
      if vertex = @u
        vertex
      else
        value = @vertices_it.next
        return nil if value.is_a?(Stop)
        @u = value
        value
      end
    end

    private def get_v(u)
      @adj_it = @graph.each_adjacent(u) if @adj_it.nil?

      if iterator = @adj_it
        value = iterator.next
        return nil if value.is_a?(Stop)
        value
      end
    end
  end
end
