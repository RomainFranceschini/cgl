require "./../../spec_helper"

include CGL

describe CGL do
  describe "Graph" do
    describe "properties" do
      it "#connected?" do
        Graph(Int32).new(edges: {
          {1, 2}, {1, 3}, {3, 4},
          {5, 6}, {6, 7}, {7, 5},
        }).connected?.should be_false

        Graph(Int32).new(edges: {
          {1, 2}, {1, 3}, {3, 4},
        }).connected?.should be_true
      end
    end

    describe "connected components" do
      it "can be counted" do
        g = Graph(Int32).new(edges: {
          {1, 2}, {1, 3}, {3, 4},
          {5, 6}, {6, 7}, {7, 5},
        })
        g.count_connected_components.should eq(2)

        g2 = Graph(Int32).new(edges: { {5, 6}, {6, 7}, {7, 5} })
        g2.count_connected_components.should eq(1)

        Graph(Int32).new.count_connected_components.should eq(0)
      end

      it "can be enumerated" do
        g = Graph(Int32).new(edges: {
          {1, 2}, {1, 3}, {3, 4},
          {5, 6}, {6, 7}, {7, 5},
        })

        components = [
          [1, 3, 4, 2],
          [5, 7, 6],
        ]

        i = 0
        g.each_connected_component { |component|
          component.should eq(components[i])
          i += 1
        }
      end

      it "can be iterated" do
        g = Graph(Int32).new(edges: {
          {1, 2}, {1, 3}, {3, 4},
          {5, 6}, {6, 7}, {7, 5},
        })

        iterator = g.each_connected_component
        iterator.next.should eq([1, 3, 4, 2])
        iterator.next.should eq([5, 7, 6])
        iterator.next.should be_a(Iterator::Stop)
      end
    end
  end
end
