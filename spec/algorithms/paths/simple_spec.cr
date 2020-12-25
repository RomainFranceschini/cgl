require "./../../spec_helper"

include CGL

describe CGL do
  describe "Graph" do
    describe "count all paths" do
      it "is computed for unweighted digraphs" do
        g = DiGraph(Int32).new(edges: {
          {1, 2}, {2, 3}, {3, 4}, {2, 4}, {2, 5}, {1, 4}, {4, 5},
        })
        g.count_simple_paths(1, 5).should eq 4
        g.count_simple_paths(5, 1).should eq 0
      end
    end
  end
end
