module CGL
  # A 'Visitor' provides
  #
  # Note: if you care about ordering, use an iterator instead.
  module Visitor(V)
    abstract def visit(visitable)

    def visit_vertices? : Bool
      false
    end

    def visit_edges? : Bool
      true
    end

    def accept(graph : AnyGraph(V))
      visitable.accept(self)
    end
  end

  class AnyGraph(V)
    def accept(visitor : Visitor(V))
      if visitor.visit_vertices?
        each_vertex { |v| visitor.visit(v) }
      end
      if visitor.visit_edges?
        each_edge { |edge| visitor.visit(edge) }
      end
    end
  end
end
