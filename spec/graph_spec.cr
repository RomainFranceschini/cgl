require "./spec_helper"

include CGL

describe CGL do
  describe "Graph" do
    it "#weighted?" do
      Graph(Int32).new.weighted?.should be_false
      WeightedGraph(Int32, Int32).new.weighted?.should be_true
      LabeledGraph(Int32, Char).new.weighted?.should be_false
      WeightedLabeledGraph(Int32, Int32, Char).new.weighted?.should be_true
    end

    it "#labeled?" do
      Graph(Int32).new.labeled?.should be_false
      WeightedGraph(Int32, Int32).new.labeled?.should be_false
      LabeledGraph(Int32, Char).new.labeled?.should be_true
      WeightedLabeledGraph(Int32, Int32, Char).new.labeled?.should be_true
    end

    describe "#density" do
      it "returns 0 when graph is empty" do
        Graph(Int32).new.density.should eq 0
      end

      it "returns 1 when graph is dense" do
        Graph(Int32).new(edges: {
          {1, 2},
        }).density.should eq 1
      end

      it "computes density" do
        Graph(Int32).new(
          vertices: {1, 2, 3},
          edges: { {1, 2}, {2, 3} }
        ).density.should be_close(0.66666, 1e-5)
      end

      it "returns > 1 for dense graphs with self-loops" do
        Graph(Int32).new(edges: {
          {1, 1}, {1, 2}, {2, 2},
        }).density.should be_close(3, Float64::EPSILON)
      end
    end

    describe "subgraph" do
      it "gives subgraph based on vertices" do
        g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
        sub = g.subgraph(["a", "b"])
        sub.order.should eq(2)
        sub.size.should eq(1)

        sub.has_vertex?("a").should be_true
        sub.has_vertex?("b").should be_true
        sub.has_edge?("a", "b").should be_true

        v1 = sub.vertices
        v2 = (Set.new(g.vertices) & Set.new(v1)).to_a # vertices from graph in subgraph

        v1.size.times do |i|
          v1[i].should eq(v2[i])
          v1[i].should be(v2[i])
        end
      end

      it "gives subgraph based on edges" do
        g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
        sub = g.subgraph([g.edge("a", "b")])
        sub.order.should eq(2)
        sub.size.should eq(1)

        sub.has_vertex?("a").should be_true
        sub.has_vertex?("b").should be_true
        sub.has_edge?("a", "b").should be_true

        v1 = sub.vertices
        v2 = (Set.new(g.vertices) & Set.new(v1)).to_a # vertices from graph in subgraph

        v1.size.times do |i|
          v1[i].should eq(v2[i])
          v1[i].should be(v2[i])
        end
      end

      it "may clone values" do
        a = Foo.new("a")
        b = Foo.new("b")
        c = Foo.new("c")

        g = Graph(Foo).new(edges: [{a, b}, {b, c}, {a, c}])
        sub = g.subgraph([g.edge(a, b)], clone: true)
        sub2 = g.subgraph([a, b], clone: true)

        vsub1 = sub.vertices
        vsub2 = sub2.vertices

        vg = Array(Foo).new # vertices from graph in subgraphs
        g.vertices.each do |v|
          vg << v if vsub1.includes?(v)
        end

        vg.size.times do |i|
          vsub1[i].should eq(vg[i])
          vsub1[i].should_not be(vg[i])

          vsub2[i].should eq(vg[i])
          vsub2[i].should_not be(vg[i])
        end
      end
    end

    it "clears" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
      g.clear
      g.empty?.should be_true
      g.size.should eq(0)
      g.order.should eq(0)
    end

    describe "remove_vertex" do
      it "removes vertex and associated edges" do
        g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
        g.remove_vertex("b")
        g.size.should eq(1)

        g.has_edge?("a", "b").should be_false
        g.has_edge?("b", "c").should be_false
        g.has_edge?("b", "a").should be_false
        g.has_edge?("c", "b").should be_false

        g.has_vertex?("b").should be_false
        g.has_vertex?("a").should be_true
        g.has_vertex?("c").should be_true
      end

      it "handles self loops" do
        g = Graph(String).new(edges: [{"a", "a"}])
        g.size.should eq(1)
        g.remove_vertex("a")
        g.size.should eq(0)
        g.empty?.should be_true
      end
    end

    describe "remove_edge" do
      it "deletes edge not found" do
        g = Graph(String).new(edges: [{"a", "b"}])
        g.remove_edge("a", "c").should be_nil
        g.size.should eq(1)
      end

      it "deletes given edge" do
        g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
        g.remove_edge("a", "c").should eq(Edge(String).new("a", "c"))
        g.size.should eq(2)

        g.remove_edge("c", "b").should eq(Edge(String).new("b", "c"))
        g.size.should eq(1)
      end

      it "deletes self loops" do
        g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "b"}])
        g.size.should eq(4)
        g.remove_edge("b", "b").should eq(Edge(String).new("b", "b"))
        g.size.should eq(3)
      end

      describe "with block" do
        it "returns the edge if found" do
          g = Graph(String).new(edges: [{"a", "b"}])
          g.remove_edge("b", "a") { 1 }.should eq(Edge(String).new("b", "a"))
          g.size.should eq(0)
        end

        it "returns the value of the block if edge is not found" do
          g = Graph(String).new(edges: [{"a", "b"}])
          g.remove_edge("c", "b") { 1 }.should eq(1)
          g.size.should eq(1)
        end
      end
    end

    it "computes hash" do
      g1 = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
      g2 = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
      g1.hash.should eq(g2.hash)

      g3 = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
      g4 = Graph(String).new(edges: [{"c", "b"}, {"a", "c"}, {"b", "a"}])
      g3.hash.should eq(g4.hash)
    end

    it "returns vertices" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
      g.vertices.should eq(["a", "b", "c"])
    end

    it "returns the degree of a given vertex" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"d", "b"}])
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
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"d", "b"}])
      g.order.should eq(4)
    end

    it "#size returns the number of edges" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"d", "b"}])
      g.size.should eq(3)
    end

    it "#empty? checks whether graph has edges" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"d", "b"}])
      g.empty?.should be_false
      g = Graph(String).new
      g.empty?.should be_true
      g = Graph(String).new(["a", "b"])
      g.empty?.should be_true
    end

    it "returns whether a vertex is included" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}])
      g.has_vertex?("a")
    end

    describe "#==" do
      it "checks equality against vertices" do
        g1 = Graph(String).new(["a", "b", "c"])
        g2 = Graph(String).new(["b", "a", "c"])
        g3 = Graph(String).new(["a", "b", "c", "d"])
        g4 = Graph(String).new(["a", "b", "d"])

        g1.should eq(g2)
        g2.should_not eq(g3)
        g2.should_not eq(g4)
      end

      it "checks equality against edges" do
        g1 = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
        g2 = Graph(String).new(["d"], [{"a", "b"}, {"b", "c"}, {"a", "c"}])
        g3 = Graph(String).new(edges: [{"a", "b"}, {"c", "b"}, {"c", "a"}, {"d", "b"}])

        g1.should_not eq(g2)
        g1.should eq(g3)
      end
    end

    describe "edges" do
      it "returns a list of edges" do
        edges = [{"a", "b"}, {"b", "c"}, {"a", "c"}]
        g = Graph(String).new(edges: edges)
        Set.new(g.edges.map { |e| Set.new({e.u, e.v}) }).should eq(Set.new(edges.map { |t| Set.new(t) }))
      end
    end

    it "disallow directed and/or multiple edges" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "a"}, {"a", "b"}])

      g.degree_of("a").should eq 1
      g.degree_of("b").should eq 1
    end

    it "allows self loops" do
      g = Graph(String).new(edges: [{"a", "a"}])
      g.size.should eq(1)
      g.order.should eq(1)
      g.degree_of("a").should eq(2)
      g.has_edge?("a", "a").should be_true
    end

    it "enumerate vertices" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
      vertices = Set{"a", "b", "c", "d"}
      g.each_vertex { |v| vertices.includes?(v).should be_true }
    end

    it "enumerate edges" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
      edges = Set{ {"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"} }
      g.each_edge { |e| edges.includes?(e.to_tuple).should be_true }
    end

    it "enumerate adjacencies" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}])
      g.each_adjacent("a") { |v| Set{"b", "c"}.includes?(v).should be_true }
      g.each_adjacent("b") { |v| Set{"a", "c", "d"}.includes?(v).should be_true }
      g.each_adjacent("c") { |v| Set{"a", "b"}.includes?(v).should be_true }
      g.each_adjacent("d") { |v| v.should eq("b") }
    end

    it "gets each vertex iterator" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}])
      nodes = Set{"a", "b", "c"}

      iter = g.each_vertex
      nodes.includes?(iter.next).should be_true
      nodes.includes?(iter.next).should be_true
      nodes.includes?(iter.next).should be_true
      iter.next.should be_a(Iterator::Stop)
    end

    it "get each adjacent iterator" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}])
      nodes = Set{"a", "c"}
      iter = g.each_adjacent("b")
      nodes.includes?(iter.next).should be_true
      nodes.includes?(iter.next).should be_true
      iter.next.should be_a(Iterator::Stop)
    end

    it "gets each edge iterator" do
      g = Graph(String).new(edges: [{"a", "b"}, {"b", "c"}])
      edges = Set{Edge(String).new("a", "b"), Edge(String).new("b", "c")}
      iter = g.each_edge
      edges.includes?(iter.next).should be_true
      edges.includes?(iter.next).should be_true
      iter.next.should be_a(Iterator::Stop)
    end

    describe "dup" do
      it "dups empty graph" do
        g1 = Graph(String).new
        g2 = g1.dup
        g2.should be_a(Graph(String))
        g2.should_not be(g1)
        g2.empty?.should be_true
      end

      it "dups graph" do
        g1 = Graph(String).new(edges: [{"a", "b"}, {"a", "c"}, {"b", "c"}, {"d", "c"}, {"d", "d"}])
        g2 = g1.dup
        g2.should_not be(g1)
        g1.should eq(g2)

        v1 = g1.vertices
        v2 = g2.vertices

        v1.size.times do |i|
          v1[i].should be(v2[i])
        end
      end
    end

    describe "clone" do
      it "clones empty graph" do
        g1 = Graph(String).new
        g2 = g1.clone
        g2.should be_a(Graph(String))
        g2.should_not be(g1)
        g2.empty?.should be_true
      end

      it "clones graph" do
        g1 = Graph(Foo).new(edges: [{Foo.new("a"), Foo.new("b")}])
        g2 = g1.clone
        g2.should be_a(Graph(Foo))
        g2.should_not be(g1)
        g1.size.should eq(g2.size)
        g1.should eq(g2)

        v1 = g1.vertices
        v2 = g2.vertices

        v1.size.times do |i|
          v1[i].should eq(v2[i])
          v1[i].should_not be(v2[i])
        end
      end
    end
  end
end
