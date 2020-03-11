module CGL
  class LabeledGraph(V, L)
    include IGraph(V)
    include AdjacencyHash(V, Nil, L)

    # The block triggered for default labels.
    @block : (-> L)

    def initialize(vertices : Enumerable(V)? = nil, edges : Enumerable(Tuple(V, V))? = nil, labels : Enumerable(L)? = nil, &block : -> L)
      @block = block
      super(vertices, edges, labels: labels)
    end

    def initialize(vertices : Enumerable(V)? = nil, edges : Enumerable(Tuple(V, V))? = nil, labels : Enumerable(L)? = nil, *, default_label : L)
      @block = ->{ default_label }
      super(vertices, edges, labels: labels)
    end

    def initialize(edges : Enumerable(AnyEdge(V))? = nil, *, default_label : L)
      @block = ->{ default_label }
      super(edges)
    end

    def initialize(edges : Enumerable(AnyEdge(V))? = nil, &block : -> L)
      @block = block
      super(edges)
    end

    def default_label : L
      @block.call
    end

    def default_weight : Nil
      nil
    end

    protected def unchecked_edge(u : V, v : V)
      LEdge(V, L).new(u, v, unsafe_fetch(u, v).last)
    end

    def dup
      LabeledGraph(V, L).new(self.each_edge, &@block)
    end
  end
end
