# Crystal Graph Library (CGL)

[![Build Status](https://github.com/RomainFranceschini/cgl/workflows/Build%20Status/badge.svg?branch=master)](https://github.com/RomainFranceschini/cgl/actions)

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

```crystal
require "cgl"
```

## Contributing

1. Fork it (<https://github.com/RomainFranceschini/cgl/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Romain Franceschini](https://github.com/RomainFranceschini) - creator and maintainer
