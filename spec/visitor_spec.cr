require "./spec_helper"

include CGL

private class MyVisitor(V)
  include Visitor(V)

  getter vertices = Set(V).new
  getter edges = Set(AnyEdge(V)).new

  def initialize(@visit_vertices = true, @visit_edges = true)
  end

  def visit_vertices?
    @visit_vertices
  end

  def visit_edges?
    @visit_edges
  end

  def visit(v)
    @vertices << v
  end

  def visit(edge : AnyEdge(V))
    @edges << edge
  end
end

describe CGL do
  describe "while visiting IGraphs" do
    it "vertices can be visited" do
      g = DiGraph(Int32).new(edges: { {1, 2}, {1, 6}, {2, 3}, {2, 4}, {4, 5}, {6, 4} })
      visitor = MyVisitor(Int32).new(true, false)
      g.accept(visitor)
      visitor.vertices.should eq(Set{1, 2, 3, 4, 5, 6})
    end

    it "vertices can be ignored" do
      g = DiGraph(Int32).new(edges: { {1, 2}, {1, 6}, {2, 3}, {2, 4}, {4, 5}, {6, 4} })
      visitor = MyVisitor(Int32).new(false, false)
      g.accept(visitor)
      visitor.vertices.should be_empty
    end

    it "edges can be visited" do
      g = DiGraph(Int32).new(edges: { {1, 2}, {1, 6}, {2, 3}, {2, 4}, {4, 5}, {6, 4} })
      visitor = MyVisitor(Int32).new(false, true)
      g.accept(visitor)
      (visitor.edges == Set{
        DiEdge.new(1, 2), DiEdge.new(1, 6), DiEdge.new(2, 3),
        DiEdge.new(2, 4), DiEdge.new(4, 5), DiEdge.new(6, 4),
      }).should be_true
    end

    it "vertices can be ignored" do
      g = DiGraph(Int32).new(edges: { {1, 2}, {1, 6}, {2, 3}, {2, 4}, {4, 5}, {6, 4} })
      visitor = MyVisitor(Int32).new(false, false)
      g.accept(visitor)
      visitor.edges.should be_empty
    end
  end
end
