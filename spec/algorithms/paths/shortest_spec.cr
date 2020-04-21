require "./../../spec_helper"

include CGL

describe CGL do
  describe "Graph" do
    describe "shortest path between two vertices" do
      it "is computed for unweighted graphs" do
        g = Graph(Int32).new(edges: {
          {1, 2}, {1, 3},
          {2, 4}, {3, 5}, {3, 6},
          {4, 7}, {5, 7}, {5, 8}, {5, 6},
          {8, 9}, {8, 10},
          {9, 10},
        })
        g.shortest_path(10, 6).should eq [10, 8, 5, 6]
        g.shortest_path(5, 1).should eq [5, 3, 1]
        g.shortest_path(6, 1).should eq [6, 3, 1]
        g.shortest_path(7, 1).should eq [7, 4, 2, 1] # or [7, 5, 3, 1]

        g.shortest_path(5, 5).should eq [5]

        g.add_vertex 11
        expect_raises(GraphError) do
          g.shortest_path(5, 11)
        end

        expect_raises(GraphError) do
          g.shortest_path(5, 12)
        end

        expect_raises(GraphError) do
          g.shortest_path_dijkstra(10, 6)
        end
      end

      it "is computed for unweighted digraphs" do
        g = DiGraph(Int32).new(edges: {
          {1, 2}, {2, 3}, {3, 1}, {1, 4},
        })
        g.shortest_path(1, 4).should eq [1, 4]
        g.shortest_path(2, 4).should eq [2, 3, 1, 4]

        expect_raises(GraphError) do
          g.shortest_path(4, 1)
        end
      end

      it "is computed for weighted graphs" do
        g = WeightedGraph(String, Int32).new
        g.add_edge("MAR", "STR", 809)
        g.add_edge("MAR", "MON", 171)
        g.add_edge("MAR", "LYO", 375)
        g.add_edge("LYO", "STR", 494)
        g.add_edge("LYO", "MON", 303)
        g.add_edge("LYO", "PAR", 465)
        g.add_edge("MON", "STR", 797)
        g.add_edge("MON", "POI", 557)
        g.add_edge("BOR", "POI", 237)
        g.add_edge("POI", "PAR", 237)
        g.add_edge("BOR", "NAN", 334)
        g.add_edge("BRE", "NAN", 298)
        g.add_edge("BRE", "PAR", 593)
        g.add_edge("NAN", "ARR", 561)
        g.add_edge("NAN", "PAR", 386)
        g.add_edge("ARR", "PAR", 185)
        g.add_edge("ARR", "STR", 522)

        g.shortest_path("ARR", "MAR").should eq(["ARR", "PAR", "LYO", "MAR"])
        g.shortest_path("MON", "BRE").should eq(["MON", "LYO", "PAR", "BRE"])

        g.add_vertex("UNK")
        expect_raises(GraphError) do
          g.shortest_path("PAR", "UNK")
        end
      end

      it "detects negative weights and raises" do
        g = WeightedGraph(Char, Int8).new
        g.add_edge('a', 'b', 2)
        g.add_edge('b', 'c', 3)
        g.add_edge('a', 'c', -2)

        expect_raises(GraphError) do
          g.shortest_path_dijkstra('a', 'c')
        end
      end

      it "is computed for weighted digraphs" do
        g = WeightedDiGraph(Char, Int8).new
        g.add_edge('a', 'b', 4)
        g.add_edge('a', 'c', 3)
        g.add_edge('b', 'c', 5)
        g.add_edge('b', 'd', 2)
        g.add_edge('c', 'd', 7)
        g.add_edge('d', 'e', 2)
        g.add_edge('e', 'b', 4)
        g.add_edge('e', 'a', 4)
        g.add_edge('e', 'f', 6)

        g.shortest_path('a', 'e').should eq(['a', 'b', 'd', 'e'])
        g.shortest_path('e', 'a').should eq(['e', 'a'])

        expect_raises(GraphError) do
          g.shortest_path('f', 'a')
        end
      end
    end
  end
end
