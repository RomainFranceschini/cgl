require "./spec_helper"

include CGL

describe CGL do
  describe "undirected graphs" do
    it "can be traversed with a breadth-first search iterator" do
      g = Graph(Int32).new(edges: { {1, 2}, {1, 3}, {2, 4}, {2, 5}, {3, 6}, {5, 7} })
      g.breadth_first_search(1).to_a.should eq([1, 2, 3, 4, 5, 6, 7])
      g.breadth_first_search(2).to_a.should eq([2, 1, 4, 5, 3, 7, 6])
    end

    it "can be traversed with a breadth-first search enumerator" do
      g = Graph(Int32).new(edges: { {1, 2}, {1, 3}, {2, 4}, {2, 5}, {3, 6}, {5, 7} })

      a_seq = [] of Int32
      g.breadth_first_search(1) { |v| a_seq << v }
      a_seq.should eq([1, 2, 3, 4, 5, 6, 7])

      b_seq = [] of Int32
      g.breadth_first_search(2) { |v| b_seq << v }
      b_seq.should eq([2, 1, 4, 5, 3, 7, 6])
    end

    it "can be traversed with a depth-first search iterator" do
      g = Graph(Int32).new(edges: { {1, 2}, {1, 3}, {2, 4}, {2, 5}, {3, 6}, {5, 7} })
      g.depth_first_search(1).to_a.should eq([1, 3, 6, 2, 5, 7, 4])
      g.depth_first_search(2).to_a.should eq([2, 5, 7, 4, 1, 3, 6])
    end

    it "can be traversed with a depth-first search enumerator" do
      g = Graph(Int32).new(edges: { {1, 2}, {1, 3}, {2, 4}, {2, 5}, {3, 6}, {5, 7} })

      a_seq = [] of Int32
      g.depth_first_search(1) { |v| a_seq << v }
      a_seq.should eq([1, 3, 6, 2, 5, 7, 4])

      b_seq = [] of Int32
      g.depth_first_search(2) { |v| b_seq << v }
      b_seq.should eq([2, 5, 7, 4, 1, 3, 6])
    end

    it "can be fully traversed with a recursive DFS iterator" do
      g = Graph(Int32).new(edges: { {1, 2}, {2, 3}, {3, 4}, {5, 6} })
      g.depth_first_search.to_a.should eq([1, 2, 3, 4, 5, 6])
    end

    it "can be fully traversed with a recursive DFS enumerator" do
      g = Graph(Int32).new(edges: { {1, 2}, {2, 3}, {3, 4}, {5, 6} })
      seq = [] of Int32
      g.depth_first_search { |v| seq << v }
      seq.should eq([1, 2, 3, 4, 5, 6])
    end
  end

  describe "directed graphs" do
    it "can be traversed with a breadth-first search (BFS) iterator" do
      g = DiGraph(Int32).new(edges: { {1, 2}, {1, 6}, {2, 3}, {2, 4}, {4, 5}, {6, 4} })
      g.breadth_first_search(1).to_a.should eq([1, 2, 6, 3, 4, 5])
      g.breadth_first_search(2).to_a.should eq([2, 3, 4, 5])
    end

    it "can be traversed with a breadth-first search enumerator" do
      g = DiGraph(Int32).new(edges: { {1, 2}, {1, 6}, {2, 3}, {2, 4}, {4, 5}, {6, 4} })

      a_seq = [] of Int32
      g.breadth_first_search(1) { |v| a_seq << v }
      a_seq.should eq([1, 2, 6, 3, 4, 5])

      b_seq = [] of Int32
      g.breadth_first_search(2) { |v| b_seq << v }
      b_seq.should eq([2, 3, 4, 5])
    end

    it "can be traversed with a depth-first search (DFS) iterator" do
      g = DiGraph(Int32).new(edges: { {1, 2}, {1, 6}, {2, 3}, {2, 4}, {4, 5}, {6, 4} })
      g.depth_first_search(1).to_a.should eq([1, 6, 4, 5, 2, 3])
      g.depth_first_search(2).to_a.should eq([2, 4, 5, 3])
    end

    it "can be traversed with a depth-first search enumerator" do
      g = DiGraph(Int32).new(edges: { {1, 2}, {1, 6}, {2, 3}, {2, 4}, {4, 5}, {6, 4} })

      a_seq = [] of Int32
      g.depth_first_search(1) { |v| a_seq << v }
      a_seq.should eq([1, 6, 4, 5, 2, 3])

      b_seq = [] of Int32
      g.depth_first_search(2) { |v| b_seq << v }
      b_seq.should eq([2, 4, 5, 3])
    end
  end
end
