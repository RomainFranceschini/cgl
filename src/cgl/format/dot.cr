module CGL
  class DotVisitor(V)
    include Visitor(V)

    def initialize(@graph : AnyGraph(V), @io : IO)
    end

    private def write(str)
      @io.puts str
    end

    def generate
      write @graph.directed? ? "digraph" : "graph"
      write '{'

      @graph.accept(self)

      write '}'
    end

    def visit(edge : Undirected(V))
      write "\"#{edge.u}\" -- \"#{edge.v}\";"
    end

    def visit(edge : Directed(V))
      write "\"#{edge.u}\" -> \"#{edge.v}\";"
    end

    def visit(visitable)
    end
  end

  class AnyGraph(V)
    # Generates a DOT file representing the graph at the given *path*.
    def to_dot(path : String)
      path = "#{path}.dot" if File.extname(path).empty?
      File.open(path, "w+") { |file| to_dot(file) }
    end

    # Generates a DOT representation of the graph using the given `IO`.
    def to_dot(io : IO)
      DotVisitor.new(self, io).generate
    end
  end
end
