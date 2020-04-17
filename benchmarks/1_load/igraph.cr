@[Link(ldflags: "`pkg-config igraph --libs`")]
lib LibIGraph
  fun read_graph_edgelist = igraph_read_graph_edgelist(graph : Void*, instream : Void*, n : LibC::Int, directed : LibC::Int) : LibC::Int
  fun vcount = igraph_vcount(graph : Void*) : LibC::Int
  fun ecount = igraph_ecount(graph : Void*) : LibC::Int
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

p LibIGraph.vcount(pointerof(graph_ptr))
p LibIGraph.ecount(pointerof(graph_ptr))

LibIGraph.destroy(graph_ptr)
