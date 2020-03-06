module CGL
  class WeightedGraph(V, W)
    include IGraph(V)
    include AdjacencyHash(V, W)

    def initialize(vertices : Array(V)? = nil, edges : Array(Tuple(V, V))? = nil, labels : Array(W)? = nil)
      {% if !W.union? && (W < Number::Primitive) %}
        # Support number types
      {% else %}
        {{ raise "Can only create weighted graphs with primitive number types, use a labeled graph instead to associate #{W} with an edge." }}
      {% end %}

      super(vertices, edges, labels)
    end

    def self.default_edge_attr
      1
    end

    def each_edge(& : AnyEdge(V) ->)
      visited = Set(WEdge(V, W)).new
      each_vertex do |u|
        each_adjacent(u) do |v|
          edge = WEdge(V, W).new(u, v, unsafe_fetch(u, v))
          if !visited.includes?(edge)
            visited << edge
            yield edge
          end
        end
      end
    end

    def each_edge_from(u : V, & : AnyEdge(V) ->)
      each_adjacent(u) { |v| yield WEdge(V, W).new(u, v, unsafe_fetch(u, v)) }
    end
  end
end
