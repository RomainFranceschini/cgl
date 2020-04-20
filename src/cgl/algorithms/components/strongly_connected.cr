module CGL
  class AbstractDiGraph(V)
    # Yields each **strongly** connected component of `self` as an `Array'.
    #
    # Note: Based on (Tarjan, 1972) and (Nuutila and Soisalon-Soinen, 1994)
    def each_strongly_connected_component
      preorder = Hash(V, Int32).new
      lowlink = Hash(V, Int32).new
      found = Set(V).new
      to_visit = Deque(V).new
      i = 0

      each_vertex do |source|
        unless found.includes?(source)
          queue = Deque(V){source}
          until queue.empty?
            u = queue.last
            unless preorder.has_key?(u)
              i += 1
              preorder[u] = i
            end

            done = true
            each_adjacent(u) do |v|
              unless preorder.has_key?(v)
                queue.push(v)
                done = false
                break
              end
            end

            if done
              lowlink[u] = preorder[u]
              each_adjacent(u) do |v|
                unless found.includes?(v)
                  lowlink[u] = if preorder[v] > preorder[u]
                                 Math.min(lowlink[u], lowlink[v])
                               else
                                 Math.min(lowlink[u], preorder[v])
                               end
                end
              end

              queue.pop

              if lowlink[u] == preorder[u]
                strong_component = Array(V){u}
                while !to_visit.empty? && preorder[to_visit.last] > preorder[u]
                  v = to_visit.pop
                  strong_component << v
                end
                found.concat(strong_component)
                yield(strong_component)
              else
                to_visit.push(u)
              end
            end
          end
        end
      end
    end

    # Returns an iterator of **strongly** connected components.
    def each_strongly_connected_component : Iterator(Array(V))
      SCCIterator(V).new(self)
    end

    # Returns the number of **strongly** connected components in `self`.
    def count_strongly_connected_components : Int32
      each_strongly_connected_component.size
    end

    # Whether self is **strongly** connected.
    def strongly_connected? : Bool
      return false if empty?
      scc = each_strongly_connected_component.first
      scc.size == self.order
    end

    # :nodoc:
    private class SCCIterator(V) < GraphIterator(V)
      include Iterator(Array(V))

      @current_queue : Deque(V)? = nil

      def initialize(@graph : AbstractDiGraph(V))
        super(@graph)

        @found = Set(V).new
        @preorder = Hash(V, Int32).new
        @lowlink = Hash(V, Int32).new
        @to_visit = Deque(V).new
        @i = 0
      end

      private def get_queue : Deque(V)?
        if queue = @current_queue
          if queue.empty?
            if source = next_vertex
              queue.push(source)
            else
              return nil
            end
          end
          queue
        else
          if source = next_vertex
            queue = Deque(V){source}
            @current_queue = queue
            return queue
          end
          nil
        end
      end

      private def next_scc_root
        if queue = self.get_queue
          while !queue.empty?
            u = queue.last

            unless @preorder.has_key?(u)
              @i += 1
              @preorder[u] = @i
            end

            done = true
            @graph.each_adjacent(u) do |v|
              unless @preorder.has_key?(v)
                queue.push(v)
                done = false
                break
              end
            end

            if done
              @lowlink[u] = @preorder[u]
              @graph.each_adjacent(u) do |v|
                unless @found.includes?(v)
                  @lowlink[u] = if @preorder[v] > @preorder[u]
                                  Math.min(@lowlink[u], @lowlink[v])
                                else
                                  Math.min(@lowlink[u], @preorder[v])
                                end
                end
              end

              queue.pop # u

              if @lowlink[u] == @preorder[u]
                return u
              else
                @to_visit.push(u)
              end
            end
          end
        end

        nil
      end

      def next
        if u = next_scc_root
          scc = Array(V){u}
          while !@to_visit.empty? && @preorder[@to_visit.last] > @preorder[u]
            v = @to_visit.pop
            scc << v
          end
          @found.concat(scc)
          scc
        else
          stop
        end
      end

      def skip_vertex?(v : V) : Bool
        @found.includes?(v)
      end
    end
  end
end
