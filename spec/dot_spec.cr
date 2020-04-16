require "./spec_helper"

include CGL

describe CGL do
  describe DotVisitor do
    it "generates DOT for graphs" do
      expected = <<-DOT
      graph
      {
      "1" -- "2";
      "1" -- "3";
      "2" -- "4";
      "2" -- "5";
      "3" -- "6";
      "5" -- "7";
      }
      DOT

      g = Graph(Int32).new(edges: { {1, 2}, {1, 3}, {2, 4}, {2, 5}, {3, 6}, {5, 7} })
      io = IO::Memory.new
      g.to_dot(io)

      io.to_s.strip.should eq(expected)
    end

    it "generates DOT for directed graphs" do
      expected = <<-DOT
      digraph
      {
      "1" -> "2";
      "1" -> "3";
      "2" -> "4";
      "2" -> "5";
      "3" -> "6";
      "5" -> "7";
      }
      DOT

      g = DiGraph(Int32).new(edges: { {1, 2}, {1, 3}, {2, 4}, {2, 5}, {3, 6}, {5, 7} })
      io = IO::Memory.new
      g.to_dot(io)

      io.to_s.strip.should eq(expected)
    end
  end
end
