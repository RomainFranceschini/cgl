require "./../../spec_helper"

include CGL

describe CGL do
  describe "DiGraph" do
    describe "properties" do
      it "#weakly_connected?" do
        DiGraph(Int32).new(edges: {
          {1, 2}, {1, 3},
          {4, 5}, {6, 7},
        }).weakly_connected?.should be_false

        DiGraph(Int32).new(edges: { {1, 2}, {1, 3} })
          .weakly_connected?
          .should be_true
      end
    end

    describe "weakly connected components" do
      it "can be counted" do
        DiGraph(Int32).new(edges: {
          {1, 2}, {1, 3}, # 1
          {4, 5},         # 2
          {6, 7}, {7, 8}, # 3
        }).count_weakly_connected_components.should eq 3

        DiGraph(Int32).new(edges: {
          {1, 2}, {1, 3}, {3, 4},
        }).count_weakly_connected_components.should eq 1

        DiGraph(Int32).new.count_weakly_connected_components.should eq(0)
      end

      it "can be enumerated" do
        g = DiGraph(Int32).new(edges: {
          {1, 2}, {1, 3},
          {4, 5}, {5, 6}, {5, 7},
        })

        components = [
          [1, 3, 2],
          [4, 5, 7, 6],
        ]

        i = 0
        g.each_weakly_connected_component { |component|
          component.should eq(components[i])
          i += 1
        }
      end

      it "can be iterated" do
        g = DiGraph(Int32).new(edges: {
          {1, 2}, {1, 3},
          {4, 5}, {5, 6}, {5, 7},
        })

        iterator = g.each_weakly_connected_component
        iterator.next.should eq([1, 3, 2])
        iterator.next.should eq([4, 5, 7, 6])
        iterator.next.should be_a(Iterator::Stop)
      end
    end
  end
end
