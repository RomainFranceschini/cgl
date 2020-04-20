module CGL
  class AbstractGraph(V)
    # Yields each connected component of `self` as an `Array'.
    def each_connected_component
      colors = Hash(V, Color).new(Color::White, self.order)
      each_vertex do |vroot|
        unless colors[vroot].black?
          component = [] of V
          depth_first_search(vroot, colors: colors) { |v| component << v }
          yield component
        end
      end
    end

    # Returns an `Iterator` of connected components.
    def each_connected_component : Iterator(Array(V))
      ComponentsIterator(V).new(self)
    end

    # Returns the number of connected components in `self`.
    def count_connected_components : Int32
      each_connected_component.size
    end

    # Whether `self` is connected.
    def connected? : Bool
      return false if empty?
      depth_first_search(self.each_vertex.first).size == self.order
    end

    # :nodoc:
    private class ComponentsIterator(V) < GraphIterator(V)
      include Iterator(Array(V))

      def initialize(@graph : AbstractGraph(V))
        super(@graph)
        @colors = Hash(V, Color).new(Color::White, graph.order)
      end

      def next
        if (u = next_vertex)
          component = [] of V
          @graph.depth_first_search(u, colors: @colors) { |v| component << v }
          component
        else
          stop
        end
      end

      def skip_vertex?(v : V) : Bool
        @colors[v].black?
      end
    end
  end
end
