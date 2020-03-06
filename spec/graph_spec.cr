require "./spec_helper"

describe CGL do
  describe "Graph" do
    it "returns vertices" do
      g = CGL::Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
      g.vertices.should eq(["a", "b", "c"])
    end

    it "returns the degree of a given vertex" do
      g = CGL::Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"d", "b"}])
      g.degree_of("a").should eq 2
      g.degree_of("b").should eq 3
      g.degree_of("c").should eq 2
      g.degree_of("d").should eq 1

      g.in_degree_of("a").should eq 2
      g.in_degree_of("b").should eq 3
      g.in_degree_of("c").should eq 2
      g.in_degree_of("d").should eq 1

      g.out_degree_of("a").should eq 2
      g.out_degree_of("b").should eq 3
      g.out_degree_of("c").should eq 2
      g.out_degree_of("d").should eq 1
    end

    it "#order returns the number of vertices" do
      g = CGL::Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"d", "b"}])
      g.order.should eq(4)
    end

    it "#size returns the number of edges" do
      g = CGL::Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"d", "b"}])
      g.size.should eq(3)
    end

    it "#empty? checks whether graph has edges" do
      g = CGL::Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"d", "b"}])
      g.empty?.should be_false
      g = CGL::Graph(String).new
      g.empty?.should be_true
      g = CGL::Graph(String).new(["a", "b"])
      g.empty?.should be_true
    end

    it "returns whether a vertex is included" do
      g = CGL::Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
      g.has_vertex?("a")
    end

    describe "#==" do
      it "checks equality against vertices" do
        g1 = CGL::Graph(String).new(["a", "b", "c"])
        g2 = CGL::Graph(String).new(["b", "a", "c"])
        g3 = CGL::Graph(String).new(["a", "b", "c", "d"])
        g4 = CGL::Graph(String).new(["a", "b", "d"])

        g1.should eq(g2)
        g2.should_not eq(g3)
        g2.should_not eq(g4)
      end

      it "checks equality against edges" do
        g1 = CGL::Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
        g2 = CGL::Graph(String).new(["d"], [{"a", "b"}, {"b", "c"}, {"a", "c"}])
        g3 = CGL::Graph(String).new(edges: [{"a", "b"}, {"c", "b"}, {"c", "a"}, {"d", "b"}])

        g1.should_not eq(g2)
        g1.should eq(g3)
      end
    end

    describe "edges" do
      it "returns a list of edges" do
        edges = [{"a", "b"}, {"b", "c"}, {"a", "c"}]
        g = CGL::Graph(String).new(edges: edges)
        Set.new(g.edges.map { |e| Set.new({e.u, e.v}) }).should eq(Set.new(edges.map { |t| Set.new(t) }))
      end
    end

    it "disallow directed and/or multiple edges" do
      g = CGL::Graph(String).new(edges: [{"a", "b"}, {"b", "a"}, {"a", "b"}])

      g.degree_of("a").should eq 1
      g.degree_of("b").should eq 1
    end

    it "allows self loops" do
      g = CGL::Graph(String).new(edges: [{"a", "a"}])
      g.size.should eq(1)
      g.order.should eq(1)
      g.degree_of("a").should eq(2)
      g.has_edge?("a", "a").should be_true
    end

    it "enumerate vertices" do
      g = CGL::Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
      vertices = Set{"a", "b", "c", "d"}
      g.each_vertex { |v| vertices.includes?(v).should be_true }
    end

    it "enumerate edges" do
      g = CGL::Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
      edges = Set{ {"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"} }
      g.each_edge { |e| edges.includes?(e.to_tuple).should be_true }
    end

    it "enumerate adjacencies" do
      g = CGL::Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
      g.each_adjacent("a") { |v| Set{"b", "c"}.includes?(v).should be_true }
      g.each_adjacent("b") { |v| Set{"a", "c", "d"}.includes?(v).should be_true }
      g.each_adjacent("c") { |v| Set{"a", "b"}.includes?(v).should be_true }
      g.each_adjacent("d") { |v| v.should eq("b") }
    end
  end
end
