require "./../../spec_helper"

include CGL

describe CGL do
  describe "DiGraph" do
    describe "properties" do
      it "#connected?" do
        DiGraph(Char).new(edges: {
          {'a', 'b'}, {'b', 'e'}, {'e', 'a'},             # 1
          {'b', 'c'}, {'e', 'f'}, {'h', 'g'},             #
          {'f', 'g'}, {'g', 'f'},                         # 2
          {'c', 'd'}, {'d', 'c'}, {'d', 'h'}, {'h', 'd'}, # 3
        }).strongly_connected?.should be_false

        DiGraph(Int32).new(edges: {
          {1, 2}, {2, 3}, {3, 1},
        }).strongly_connected?.should be_true
      end
    end

    describe "strongly connected components" do
      it "can be counted" do
        DiGraph(Char).new(edges: {
          {'a', 'b'}, {'b', 'e'}, {'e', 'a'},             # 1
          {'b', 'c'}, {'e', 'f'}, {'h', 'g'},             #
          {'f', 'g'}, {'g', 'f'},                         # 2
          {'c', 'd'}, {'d', 'c'}, {'d', 'h'}, {'h', 'd'}, # 3
        }).count_strongly_connected_components.should eq(3)

        DiGraph(Int32).new(edges: {
          {1, 2}, {2, 3}, {3, 1},
        }).count_strongly_connected_components.should eq 1

        DiGraph(Int32).new.count_strongly_connected_components.should eq 0
      end

      it "can be enumerated" do
        g = DiGraph(Char).new(edges: {
          {'a', 'b'}, {'b', 'e'}, {'e', 'a'},             # 1
          {'b', 'c'}, {'e', 'f'}, {'h', 'g'},             #
          {'f', 'g'}, {'g', 'f'},                         # 2
          {'c', 'd'}, {'d', 'c'}, {'d', 'h'}, {'h', 'd'}, # 3
        })

        expected = [
          ['f', 'g'],
          ['c', 'd', 'h'],
          ['a', 'b', 'e'],
        ]

        i = 0
        g.each_strongly_connected_component do |scc|
          scc.should eq(expected[i])
          i += 1
        end
      end

      it "can be iterated" do
        g = DiGraph(Char).new(edges: {
          {'a', 'b'}, {'b', 'e'}, {'e', 'a'},             # 1
          {'b', 'c'}, {'e', 'f'}, {'h', 'g'},             #
          {'f', 'g'}, {'g', 'f'},                         # 2
          {'c', 'd'}, {'d', 'c'}, {'d', 'h'}, {'h', 'd'}, # 3
        })

        iterator = g.each_strongly_connected_component
        iterator.next.should eq ['f', 'g']
        iterator.next.should eq ['c', 'd', 'h']
        iterator.next.should eq ['a', 'b', 'e']
        iterator.next.should be_a(Iterator::Stop)
      end
    end
  end
end
