require "./spec_helper"

describe CGL do
  describe "WeightedGraph" do
    describe "edges" do
      it "returns a list of weighted edges" do
        edges = [{"a", "b"}, {"b", "c"}, {"a", "c"}]
        g = CGL::WeightedGraph(String, Int32).new(edges: edges)
        g.edges.class.should eq(Array(CGL::AnyEdge(String)))
        g.edges.first.class.should eq(CGL::WEdge(String, Int32))
        g.edges.size.should eq(3)
      end

      it "can be enumerated" do
        g = CGL::WeightedGraph(String, Int32).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}], weights: [2, 4, 8, 2])
        edges = Set.new([{"a", "b", 2}, {"b", "c", 4}, {"a", "c", 8}, {"b", "d", 2}].map { |t| CGL::WEdge(String, Int32).new(t[0], t[1], t[2]) })

        count = 0

        g.each_edge { |e|
          count += 1
          edges.includes?(e).should be_true
        }

        count.should eq(4)
      end
    end
  end
end
