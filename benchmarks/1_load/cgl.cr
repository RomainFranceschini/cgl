require "../../src/cgl"

path = ARGV.fetch(0, "benchmarks/data/amazon0302.txt")

g = CGL::DiGraph(Int32).new
File.open(path) do |file|
  file.each_line do |line|
    next if line.starts_with?('#')
    u, v = line.split
    g.add_edge(u.to_i, v.to_i)
  end
end

GC.collect
heap_size = GC.stats.heap_size
mb = heap_size / 1024.0 / 1024.0
puts "memory usage: #{mb}MB"

puts g.order
puts g.size

# g.depth_first_search(0).each { }
