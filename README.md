# Crystal Graph Library (CGL)

[![Build Status](https://github.com/RomainFranceschini/cgl/workflows/CGL%20CI/badge.svg?branch=master)](https://github.com/RomainFranceschini/cgl/actions)

CGL is a Crystal library for the creation and manipulation of graph data structures.

All graph data structures are based on an adjacency list representation and heavily rely on Crystal `Hash` data structure.

## Features

  - [x] Data structures for graphs, digraphs and ~~multigraphs~~
  - [x] Nodes can be anything
  - [x] Edges can be weighted and/or hold arbitrary data as labels
  - [x] Generic interface for accessing concrete data structures (see `CGL::IGraph`)
  - [x] Generic interface for traversing graphs (iterators, visitor)
  - [ ] Standard graph algorithms
  - [ ] Support hypergraphs

## Documentation

* [API](https://romainfranceschini.github.io/cgl/)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     cgl:
       github: RomainFranceschini/cgl
   ```

2. Run `shards install`

## Usage

Import the CGL module with :

```crystal
require "cgl"
```

Directed and undirected graphs types are provided. For each of those, multiple
variants are offered so users can carefully select the ones that consume the
least memory for their needs.

### Undirected graphs

The following classes all implements *undirected* graphs. They allow self-loop
edges that connects a vertex to itself. They ignore multiple edges between
two vertices.

* The `Graph` class implements an *undirected* graph. Edges cannot be weighted
  nor labeled.

  ```crystal
  g = Graph(Char).new(edges: { {'a','b'}, {'a','f'}, {'f','b'} })
  g.add_edge 'b', 'b'
  g.add_vertex 'e'
  g.order # => 5
  g.size  # => 4
  ```

* The `WeightedGraph` class implements an *undirected* graph where edges can be
  weighted with a `Number::Primitive` type.

  ```crystal
  g = WeightedGraph(Char, Int32).new(default_weight: 10)
  g.add_edge 'b', 'b', 1
  g.add_edge 'a', 'b'
  g.weight_of('b', 'b') # => 1
  g.weight_of('a', 'b') # => 10
  ```

* The `LabeledGraph` class implements an *undirected* graph where edges can be
  labeled, e.g. they can hold arbitrary data of any chosen type.

  ```crystal
  g = LabeledGraph(String, Char).new(default_label: '👀')
  g.add_edge "hello", "world", label: '👍'
  g.add_edge "hello", "folks", label: '👎'
  g.add_edge "hello", "martians"
  g.label_of("hello", "martians") # => 👀
  ```

* Finally, the `WeightedLabeledGraph` class implements an *undirected* graph
  where edges can both be weighted and labeled. Yay!

  ```crystal
  g = WeightedLabeledGraph(String, Char).new(default_weight: 10, default_label: '👀')
  g.add_edge "hello", "world", weight: 1, label: '👍'
  g.add_edge "hello", "folks", label: '👎'
  ```

### Directed graphs

The following classes all implements *directed* graphs. They allow self-loop
edges, that connects a vertex to itself. They ignore multiple edges between
two vertices.

* The `DiGraph` class implements a *directed* graph. Edges cannot be weighted
  nor labeled.

  ```crystal
  g = DiGraph(Char).new(edges: { {'a','b'}, {'a','c'}, {'c','b'} })
  ```

* The `WeightedDiGraph` class implements a *directed* graph where edges can be
  weighted with a `Number::Primitive` type.

  ```crystal
  g = WeightedDiGraph(Char, UInt8).new(default_weight: 1u8)
  ```

* The `LabeledDiGraph` class implements a *directed* graph where edges can be
  labeled, e.g. they can hold arbitrary data of any chosen type.

  ```crystal
  g = LabeledDiGraph(String, Char).new(default_label: '👀')
  g.add_edge "hello", "world", label: '👍'
  ```

* Finally, the `WeightedLabeledDiGraph` class implements a *directed* graph where
  edges can both be weighted and labeled. Yay!

  ```crystal
  g = WeightedLabeledDiGraph(String, Char).new(default_weight: 10, default_label: '👀')
  ```

### Multigraphs and Hypergraphs

TBD

## Contributing

1. Fork it (<https://github.com/RomainFranceschini/cgl/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Romain Franceschini](https://github.com/RomainFranceschini) - creator and maintainer
