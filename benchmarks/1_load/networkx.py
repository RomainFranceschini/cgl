import networkx as nx
import sys

filename = sys.argv[1]
g = nx.read_edgelist(filename, delimiter="\t")

print(g.number_of_nodes())
print(g.number_of_edges())
