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

start = Time.monotonic

count = g.count_strongly_connected_components

puts "SCC: #{Time.monotonic - start}secs"
puts count
