from igraph import *
import sys

filename = sys.argv[1]
g = Graph.Read(filename, format="edges")

print(g.vcount())
print(g.ecount())
