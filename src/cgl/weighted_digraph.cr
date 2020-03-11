module CGL
  class WeightedDiGraph(V, W)
    include IGraph(V)
    include AdjacencyHash(V, W, Nil)

    def default_weight : W
      1
    end

    def default_label : Nil
      nil
    end

    def initialize(vertices : Enumerable(V)? = nil, edges : Enumerable(Tuple(V, V))? = nil, weights : Enumerable(W)? = nil)
      {% if !W.union? && (W < Number::Primitive) %}
        # Support number types
      {% else %}
        {{ raise "Can only create weighted graphs with primitive number types, use a labeled graph instead to associate #{W} with an edge." }}
      {% end %}

      super(vertices, edges, weights: weights)
    end

    def initialize(edges : Enumerable(AnyEdge(V))? = nil)
      super(edges)
    end

    protected def unchecked_edge(u : V, v : V)
      WDiEdge(V, W).new(u, v, unsafe_fetch(u, v).first)
    end
  end
end
