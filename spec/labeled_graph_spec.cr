require "./spec_helper"

describe CGL do
  describe "LabeledGraph" do
    describe "edges" do
      it "returns a list of labeled edges" do
        edges = [{"a", "b"}, {"b", "c"}, {"a", "c"}]
        g = CGL::LabeledGraph(String, Char).new(edges: edges, default_label: 'x')
        g.edges.class.should eq(Array(CGL::AnyEdge(String)))
        g.edges.first.class.should eq(CGL::LEdge(String, Char))
        g.edges.size.should eq(3)
      end

      it "can be enumerated" do
        g = CGL::LabeledGraph(String, Char).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}], labels: ['w', 'x', 'y', 'z'], default_label: 'x')
        edges = Set.new([{"a", "b", 'w'}, {"b", "c", 'x'}, {"a", "c", 'y'}, {"b", "d", 'z'}].map { |t| CGL::LEdge(String, Char).new(t[0], t[1], t[2]) })

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
