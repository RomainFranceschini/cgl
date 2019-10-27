require "./spec_helper"

describe CRL do
  describe "SimpleGraph" do
    it "returns vertices" do
      g = CRL::SimpleGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
      g.vertices.should eq(["a", "b", "c"])
    end

    it "returns the degree of a given vertex" do
      g = CRL::SimpleGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"d", "b"}])
      g.degree_of("a").should eq 2
      g.degree_of("b").should eq 3
      g.degree_of("c").should eq 2
      g.degree_of("d").should eq 1
    end

    it "#order returns the number of vertices" do
      g = CRL::SimpleGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"d", "b"}])
      g.order.should eq(4)
    end

    it "#size returns the number of edges" do
      g = CRL::SimpleGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"d", "b"}])
      g.size.should eq(3)
    end

    it "#empty? checks whether graph has edges" do
      g = CRL::SimpleGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"d", "b"}])
      g.empty?.should be_false
      g = CRL::SimpleGraph(String).new
      g.empty?.should be_true
      g = CRL::SimpleGraph(String).new(["a", "b"])
      g.empty?.should be_true
    end

    it "returns whether a vertex is included" do
      g = CRL::SimpleGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
      g.has_vertex?("a")
    end

    describe "#==" do
      it "checks equality against vertices" do
        g1 = CRL::SimpleGraph(String).new(["a", "b", "c"])
        g2 = CRL::SimpleGraph(String).new(["b", "a", "c"])
        g3 = CRL::SimpleGraph(String).new(["a", "b", "c", "d"])
        g4 = CRL::SimpleGraph(String).new(["a", "b", "d"])

        g1.should eq(g2)
        g2.should_not eq(g3)
        g2.should_not eq(g4)
      end

      it "checks equality against edges" do
        g1 = CRL::SimpleGraph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
        g2 = CRL::SimpleGraph(String).new(["d"], [{"a", "b"}, {"b", "c"}, {"a", "c"}])
        g3 = CRL::SimpleGraph(String).new(edges: [{"a", "b"}, {"c", "b"}, {"c", "a"}, {"d", "b"}])

        g1.should_not eq(g2)
        g1.should eq(g3)
      end
    end

    describe "edges" do
      it "returns a list of edges" do
        edges = [{"a", "b"}, {"b", "c"}, {"a", "c"}]
        g = CRL::SimpleGraph(String).new(edges: edges)
        Set.new(g.edges.map { |e| Set.new(e.to_tuple) }).should eq(Set.new(edges.map { |t| Set.new(t) }))
      end
    end

    it "disallow directed and/or multiple edges" do
      g = CRL::SimpleGraph(String).new(edges: [{"a", "b"}, {"b", "a"}, {"a", "b"}])

      g.degree_of("a").should eq 1
      g.degree_of("b").should eq 1
    end
  end
end
