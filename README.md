# Crystal Graph Library (CGL)

CGL is a Crystal library for the creation and manipulation of graph data structures.

All graph data structures are based on an adjacency list representation and heavily rely on the Crystal `Hash` data structure.

## Features

  - [] Data structures for graphs and digraphs and multigraphs
  - [] Standard graph algorithms
  - [] Relies on generics: nodes can be anything, edges can be weighted and hold arbitrary data
  - [] Generic interface for accessing concrete data structures (see `CGL::IGraph`)
  - [] Generic interface for traversing graphs (iterators, visitors)

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
