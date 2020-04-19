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
  end
end
