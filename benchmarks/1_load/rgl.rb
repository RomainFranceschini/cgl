require "rgl/adjacency"
require 'objspace'

path = ARGV.fetch(0, "benchmarks/data/amazon0302.txt")

g = RGL::DirectedAdjacencyGraph.new

File.open(path) do |file|
  file.each_line do |line|
    next if line.start_with?('#')
    u, v = line.split
    g.add_edge(u.to_i, v.to_i)
  end
end

heap_size = ObjectSpace.memsize_of_all
mb = heap_size / 1024.0 / 1024.0
puts "memory usage: #{mb}MB"

puts g.num_vertices
puts g.num_edges
