require "./spec_helper"

include CGL

describe CGL do
  describe "DiGraph" do
    describe "#density" do
      it "returns 0 when graph is empty" do
        DiGraph(Int32).new.density.should eq 0
      end

      it "returns 1 when graph is dense" do
        DiGraph(Int32).new(edges: {
          {1, 2}, {2, 1},
        }).density.should eq 1
      end

      it "computes density" do
        DiGraph(Int32).new(edges: {
          {1, 2},
        }).density.should be_close(0.5, Float64::EPSILON)
      end
    end

    describe "remove_vertex" do
      it "removes vertex and associated edges" do
        g = DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
        g.remove_vertex("b")
        g.size.should eq(1)

        g.has_edge?("a", "b").should be_false
        g.has_edge?("b", "a").should be_false

        g.has_vertex?("b").should be_false
        g.has_vertex?("a").should be_true
        g.has_vertex?("c").should be_true
      end

      it "handles self loops" do
        g = DiGraph(String).new(edges: [{"a", "a"}])
        g.size.should eq(1)
        g.remove_vertex("a")
        g.size.should eq(0)
        g.empty?.should be_true
      end
    end

    describe "remove_edge" do
      it "deletes self loops" do
        g = DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "b"}])
        g.size.should eq(4)
        g.remove_edge("b", "b").should eq(DiEdge(String).new("b", "b"))
        g.size.should eq(3)
      end

      it "deletes given edge" do
        g = DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}])
        g.remove_edge("b", "a").should be_nil
        g.size.should eq(2)

        g.remove_edge("a", "b").should eq(DiEdge(String).new("a", "b"))
        g.size.should eq(1)
      end

      describe "with block" do
        it "returns the edge if found" do
          g = DiGraph(String).new(edges: [{"a", "b"}])
          g.remove_edge("a", "b") { 1 }.should eq(DiEdge(String).new("a", "b"))
          g.size.should eq(0)
        end

        it "returns the value of the block if edge is not found" do
          g = DiGraph(String).new(edges: [{"a", "b"}])
          g.remove_edge("b", "a") { 1 }.should eq(1)
          g.size.should eq(1)
        end
      end
    end

    it "returns vertices" do
      g = DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
      g.vertices.should eq(["a", "b", "c"])
    end

    it "returns the degree of a given vertex" do
      g = DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"d", "b"}])

      g.in_degree_of("a").should eq 0
      g.in_degree_of("b").should eq 2
      g.in_degree_of("c").should eq 2
      g.in_degree_of("d").should eq 0

      g.out_degree_of("a").should eq 2
      g.out_degree_of("b").should eq 1
      g.out_degree_of("c").should eq 0
      g.out_degree_of("d").should eq 1

      g.degree_of("a").should eq 2
      g.degree_of("b").should eq 3
      g.degree_of("c").should eq 2
      g.degree_of("d").should eq 1
    end

    it "#size returns the number of edges" do
      g = DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"d", "b"}, {"b", "a"}])
      g.size.should eq(4)
    end

    it "edges orientation matters" do
      g = DiGraph(String).new(edges: [{"a", "b"}])
      g.out_degree_of("a").should eq 1
      g.out_degree_of("b").should eq 0

      g.has_edge?("a", "b").should be_true
      g.has_edge?("b", "a").should be_false
    end

    it "allows 2 opposite directed edges between same vertices" do
      g = DiGraph(String).new(edges: [{"a", "b"}, {"b", "a"}])
      g.out_degree_of("a").should eq 1
      g.out_degree_of("b").should eq 1

      g.has_edge?("a", "b").should be_true
      g.has_edge?("b", "a").should be_true
    end

    it "disallow multiple edges" do
      g = DiGraph(String).new(edges: [{"a", "b"}, {"b", "a"}, {"a", "b"}])
      g.size.should eq(2)
    end

    it "allows self loops" do
      g = DiGraph(String).new(edges: [{"a", "a"}])
      g.size.should eq(1)
      g.order.should eq(1)
      g.degree_of("a").should eq(2)
      g.in_degree_of("a").should eq(1)
      g.out_degree_of("a").should eq(1)
      g.has_edge?("a", "a").should be_true
    end

    it "enumerate vertices" do
      g = DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
      vertices = Set{"a", "b", "c", "d"}
      g.each_vertex { |v| vertices.includes?(v).should be_true }
    end

    it "enumerate edges" do
      g = DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
      edges = Set{ {"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"} }
      g.each_edge { |e| edges.includes?(e.to_tuple).should be_true }
    end

    it "enumerate adjacencies" do
      g = DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
      g.each_adjacent("a") { |v| Set{"b", "c"}.includes?(v).should be_true }
      g.each_adjacent("b") { |v| Set{"c", "d"}.includes?(v).should be_true }
      g.each_adjacent("c") { raise "'c' has no adjacencies" }
      g.each_adjacent("d") { raise "'d' has no adjacencies" }
    end

    it "gets each edge iterator" do
      g = DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}])
      edges = Set{DiEdge(String).new("a", "b"), DiEdge(String).new("b", "c")}
      iter = g.each_edge
      edges.includes?(iter.next).should be_true
      edges.includes?(iter.next).should be_true
      iter.next.should be_a(Iterator::Stop)
    end
  end
end
