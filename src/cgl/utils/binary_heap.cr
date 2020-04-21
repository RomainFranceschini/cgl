module CGL
  # A simple priority queue implemented as a array-based heap.
  #
  # Each inserted elements is given a certain priority, based on the result of
  # the comparison. This is a min-heap, which means retrieving an element will
  # always return the one with the highest priority.
  #
  # To avoid O(n) complexity when deleting an arbitrary element, a map is
  # used to cache indices for each element.
  class BinaryHeap(T)
    private DEFAULT_CAPACITY = 32

    # Returns the number of elements in the heap.
    getter size : Int32

    @capacity : Int32

    # Creates a new empty BinaryHeap.
    def initialize
      @size = 0
      @capacity = DEFAULT_CAPACITY
      @heap = Pointer(Tuple(Float64, T)).malloc(@capacity)
      @cache = Hash(T, Int32).new(@capacity)
    end

    def initialize(initial_capacity : Int)
      if initial_capacity < 0
        raise ArgumentError.new "Negative array size: #{initial_capacity}"
      end

      @size = 0
      @capacity = initial_capacity.to_i
      if initial_capacity == 0
        @heap = Pointer(Tuple(Float64, T)).null
      else
        @heap = Pointer(Tuple(Float64, T)).malloc(initial_capacity)
      end
      @cache = Hash(T, Int32).new(initial_capacity)
    end

    def empty? : Bool
      @size == 0
    end

    def clear
      @heap.clear(@size)
      @cache.clear
      @size = 0
      self
    end

    def peek? : T?
      peek { nil }
    end

    def peek : T
      peek { raise "heap is empty." }
    end

    def peek
      @size == 0 ? yield : @heap[1][1]
    end

    def next_priority : Float64
      next_priority { raise "heap is empty." }
    end

    def next_priority
      @size == 0 ? yield : @heap[1][0]
    end

    def pop : T
      if @size == 0
        raise "heap is empty."
      else
        _, value = delete_at(1)
        @cache.delete(value)
        value
      end
    end

    def to_slice : Slice(Tuple(Float64, T))
      (@heap + 1).to_slice(@size)
    end

    def to_a : Array(Tuple(Float64, T))
      Array(Tuple(Float64, T)).build(@size) do |pointer|
        pointer.copy_from(@heap + 1, @size)
        @size
      end
    end

    def ==(other : BinaryHeap) : Bool
      size == other.size && to_slice == other.to_slice
    end

    def ==(other) : Bool
      false
    end

    def inspect(io)
      io << "<" << self.class.name << ": size=" << size.to_s(io) << ", top="
      io << peek.to_s(io) << ">"
      nil
    end

    def push(priority : Number, value : T) : self
      @size += 1
      check_needs_resize
      @heap[@size] = {priority.to_f, value}
      @cache[value] = @size
      sift_up!(@size)
      self
    end

    def includes?(value : T) : Bool
      @cache.has_key?(value)
    end

    def delete(value : T) : T?
      raise "heap is empty" if @size == 0
      index = @cache[value]
      @cache.delete(value)
      delete_at(index)[1]
    end

    def adjust(value : T, with new_priority : Number)
      index = @cache[value]
      @heap[index] = {new_priority.to_f, value}
      if index > 1 && new_priority < @heap[index >> 1][0]
        sift_up!(index)
      else
        sift_down!(index)
      end
    end

    private def delete_at(index) : {Float64, T}
      value = @heap[index]
      @size -= 1

      if index <= @size
        new_value = @heap[@size + 1]
        @heap[index] = new_value
        @cache[new_value[1]] = index

        if index > 1 && new_value[0] < @heap[index >> 1][0]
          sift_up!(index)
        else
          sift_down!(index)
        end
      end

      value
    end

    private def sift_down!(index)
      size = @size

      loop do
        left = (index << 1)
        break if (left > size)

        right = left + 1
        min = left

        if right <= size && @heap[right][0] < @heap[left][0]
          min = right
        end

        if @heap[min][0] < @heap[index][0]
          @heap[index], @heap[min] = @heap[min], @heap[index]
          @cache[@heap[index][1]] = index
          @cache[@heap[min][1]] = min
          index = min
        else
          break
        end
      end
    end

    private def sift_up!(index)
      p = index >> 1
      while p > 0 && @heap[index][0] < @heap[p][0]
        @heap[p], @heap[index] = @heap[index], @heap[p]
        @cache[@heap[p][1]] = p
        @cache[@heap[index][1]] = index
        index = p
        p = index >> 1
      end
    end

    def heapify!
      index = @size >> 1
      while index >= 0
        sift_down!(index)
        index -= 1
      end
    end

    private def check_needs_resize
      double_capacity if @size == @capacity
    end

    private def double_capacity
      resize_to_capacity(@capacity * 2)
    end

    private def resize_to_capacity(capacity)
      @capacity = capacity
      if @heap
        @heap = @heap.realloc(@capacity)
      else
        @heap = Pointer({Float64, T}).malloc(@capacity)
      end
    end
  end
end
