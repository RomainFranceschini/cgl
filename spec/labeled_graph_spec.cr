require "./spec_helper"

include CGL

describe CGL do
  describe "LabeledGraph" do
    describe "edges" do
      it "returns a list of labeled edges" do
        edges = [{"a", "b"}, {"b", "c"}, {"a", "c"}]
        g = LabeledGraph(String, Char).new(edges: edges, default_label: 'x')
        g.edges.class.should eq(Array(AnyEdge(String)))
        g.edges.first.class.should eq(LEdge(String, Char))
        g.edges.size.should eq(3)
      end

      it "can be enumerated" do
        g = LabeledGraph(String, Char).new(edges: [{"a", "b"}, {"b", "c"}, {"a", "c"}, {"b", "d"}], labels: ['w', 'x', 'y', 'z'], default_label: 'x')
        edges = Set.new([{"a", "b", 'w'}, {"b", "c", 'x'}, {"a", "c", 'y'}, {"b", "d", 'z'}].map { |t| LEdge(String, Char).new(t[0], t[1], t[2]) })

        count = 0

        g.each_edge { |e|
          count += 1
          edges.includes?(e).should be_true
        }

        count.should eq(4)
      end

      describe "dup" do
        it "dups empty graph" do
          g1 = LabeledGraph(String, Char).new { 'x' }
          g2 = g1.dup
          g2.should be_a(LabeledGraph(String, Char))
          g2.should_not be(g1)
          g2.empty?.should be_true
        end

        it "dups graph" do
          g1 = LabeledGraph(String, String).new(edges: [{"a", "b"}, {"a", "c"}, {"b", "c"}, {"d", "c"}, {"d", "d"}], labels: ["1", "2", "3", "4", "5"]) { "0" }

          g2 = g1.dup
          g2.should be_a(LabeledGraph(String, String))
          g2.should_not be(g1)
          g1.should eq(g2)

          v1 = g1.vertices
          v2 = g2.vertices

          v1.size.times do |i|
            v1[i].should be(v2[i])
          end
        end
      end
    end
  end
end
