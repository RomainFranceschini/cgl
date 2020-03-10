require "./spec_helper"

describe CGL do
  describe "DiGraph" do
    it "returns vertices" do
      g = CGL::DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
      g.vertices.should eq(["a", "b", "c"])
    end

    it "returns the degree of a given vertex" do
      g = CGL::DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"d", "b"}])

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
      g = CGL::DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"d", "b"}, {"b", "a"}])
      g.size.should eq(4)
    end

    it "edges orientation matters" do
      g = CGL::DiGraph(String).new(edges: [{"a", "b"}])
      g.out_degree_of("a").should eq 1
      g.out_degree_of("b").should eq 0

      g.has_edge?("a", "b").should be_true
      g.has_edge?("b", "a").should be_false
    end

    it "allows 2 opposite directed edges between same vertices" do
      g = CGL::DiGraph(String).new(edges: [{"a", "b"}, {"b", "a"}])
      g.out_degree_of("a").should eq 1
      g.out_degree_of("b").should eq 1

      g.has_edge?("a", "b").should be_true
      g.has_edge?("b", "a").should be_true
    end

    it "disallow multiple edges" do
      g = CGL::DiGraph(String).new(edges: [{"a", "b"}, {"b", "a"}, {"a", "b"}])
      g.size.should eq(2)
    end

    it "allows self loops" do
      g = CGL::DiGraph(String).new(edges: [{"a", "a"}])
      g.size.should eq(2)
      g.order.should eq(1)
      g.degree_of("a").should eq(2)
      g.has_edge?("a", "a").should be_true
    end

    it "enumerate vertices" do
      g = CGL::DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
      vertices = Set{"a", "b", "c", "d"}
      g.each_vertex { |v| vertices.includes?(v).should be_true }
    end

    it "enumerate edges" do
      g = CGL::DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
      edges = Set{ {"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"} }
      g.each_edge { |e| edges.includes?(e.to_tuple).should be_true }
    end

    it "enumerate adjacencies" do
      g = CGL::DiGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
      g.each_adjacent("a") { |v| Set{"b", "c"}.includes?(v).should be_true }
      g.each_adjacent("b") { |v| Set{"c", "d"}.includes?(v).should be_true }
      g.each_adjacent("c") { raise "'c' has no adjacencies" }
      g.each_adjacent("d") { raise "'d' has no adjacencies" }
    end
  end
end
