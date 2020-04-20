from igraph import *
import time
import sys

filename = sys.argv[1]
g = Graph.Read(filename, format="edges")

start = time.monotonic()
scc_all = g.components(mode=STRONG)
print(time.monotonic() - start, "secs")
print(len(scc_all))

