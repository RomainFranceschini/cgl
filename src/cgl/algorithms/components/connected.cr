private macro def_connected_components(name)
  # Yields each connected component of `self` as an `Array'.
  def {{name.id}}
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
  def {{name.id}} : Iterator(Array(V))
    ComponentsIterator(V).new(self)
  end
end

module CGL
  # :nodoc:
  class ComponentsIterator(V) < GraphIterator(V)
    include Iterator(Array(V))

    def initialize(@graph : AnyGraph(V))
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

  class AbstractGraph(V)
    def_connected_components :each_connected_component

    # Returns the number of connected components in `self`.
    def count_connected_components : Int32
      each_connected_component.size
    end

    # Whether `self` is connected.
    def connected? : Bool
      return false if empty?
      depth_first_search(self.each_vertex.first).size == self.order
    end
  end

  class AbstractDiGraph(V)
    def_connected_components :each_weakly_connected_component

    # Returns the number of **weakly** connected components in `self`.
    def count_weakly_connected_components : Int32
      each_weakly_connected_component.size
    end

    # Whether `self` is **weakly** connected.
    def weakly_connected? : Bool
      return false if empty?
      depth_first_search(self.each_vertex.first).size == self.order
    end
  end
end
