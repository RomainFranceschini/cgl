module CGL
  abstract class GraphIterator(V)
    include Iterator(V)

    enum Color
      White
      Gray
      Black
    end

    @graph : IGraph(V)
    @deque : Deque(V)
    @colors : Hash(V, Color)

    def initialize(@graph : IGraph(V), start : V)
      unless @graph.has_vertex?(start)
        raise GraphError.new("#{start} is not a vertex from graph #{@graph}")
      end

      @deque = Deque(V){start}
      @colors = Hash(V, Color).new(Color::White, @graph.order)
      @colors[start] = Color::Gray
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

  # A `BFSIterator` can be used to traverse a graph from a given vertex `V` in
  # a Breadth-first search fashion.
  class BFSIterator(V) < GraphIterator(V)
    protected def next_vertex : V
      @deque.shift
    end
  end

  # A `DFSIterator` can be used to traverse a graph from a given vertex `V` in
  # a Depth-first search fashion.
  class DFSIterator(V) < GraphIterator(V)
    protected def next_vertex : V
      @deque.pop
    end
  end

  module IGraph(V)
    # Returns an iterator over vertices from the given source *v* in a **breadth**-first search (DFS).
    def bfs_iterator(v : V) : BFSIterator(V)
      BFSIterator(V).new(self, v)
    end

    # Returns an iterator over vertices from the given source *v* in a **depth**-first search (DFS).
    def dfs_iterator(v : V) : DFSIterator(V)
      DFSIterator(V).new(self, v)
    end
  end
end
