require "./../../spec_helper"

include CGL

describe CGL do
  describe "DiGraph" do
    describe "strongly connected components" do
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
    end
  end
end
