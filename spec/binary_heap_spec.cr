require "./spec_helper"

include CGL

describe BinaryHeap do
  describe "empty" do
    it "size should be zero" do
      heap = BinaryHeap(Nil).new
      heap.size.should eq(0)
      heap.empty?.should be_true
    end
  end

  it "does clear" do
    heap = BinaryHeap(Nil).new
    3.times { |i| heap.push(i, nil) }
    heap.clear
    heap.size.should eq(0)
  end

  it "prioritizes elements" do
    heap = BinaryHeap(Char).new
    heap.push(357, 'c')
    heap.push(2, 'a')
    heap.push(12, 'b')

    heap.next_priority.should eq(2)
    heap.pop.should eq('a')

    heap.push(0.5, 'd')

    heap.next_priority.should eq(0.5)
    heap.pop.should eq('d')

    heap.next_priority.should eq(12)
    heap.pop.should eq('b')

    heap.next_priority.should eq(357)
    heap.pop.should eq('c')
  end

  it "peek lowest priority" do
    heap = BinaryHeap(Int32).new
    n = 30
    (0...n).to_a.shuffle.each { |i|
      heap.push(i, i)
    }
    heap.peek.should eq(0)
  end

  it "deletes" do
    heap = BinaryHeap(Char).new
    heap.push(357, 'c')
    heap.push(2, 'a')
    heap.push(12, 'b')
    item = heap.delete('b')

    item.should_not be_nil
    item.should eq('b')
  end

  it "adjust" do
    heap = BinaryHeap(Char).new
    heap.push(357, 'c')
    heap.push(2, 'a')
    heap.push(12, 'b')

    heap.next_priority.should eq(2)
    heap.peek.should eq('a')

    heap.adjust('c', 1)

    heap.next_priority.should eq(1)
    heap.peek.should eq('c')
  end
end
