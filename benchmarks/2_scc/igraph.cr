@[Link(ldflags: "`pkg-config igraph --libs`")]
lib LibIGraph
  fun read_graph_edgelist = igraph_read_graph_edgelist(graph : Void*, instream : Void*, n : LibC::Int, directed : LibC::Int) : LibC::Int

  enum Mode
    Weak   = 1
    Strong = 2
  end

  fun clusters = igraph_clusters(graph : Void*, half1 : Void*, half2 : Void*, number : LibC::Int*, mode : Mode) : LibC::Int

  fun destroy = igraph_destroy(graph : Void*) : LibC::Int
end

lib LibC
  fun fopen(filename : Char*, mode : Char*) : Void*
  fun fclose(stream : Void*) : LibC::Int
end

path = ARGV[0]
stream = LibC.fopen(path, "r")

graph_ptr = Pointer(Void).malloc
LibIGraph.read_graph_edgelist(graph_ptr, stream, 0, true)
LibC.fclose(stream)

start = Time.monotonic

LibIGraph.clusters(graph_ptr, nil, nil, out count, LibIGraph::Mode::Strong)

puts "SCC: #{Time.monotonic - start}secs"
puts count

LibIGraph.destroy(graph_ptr)
