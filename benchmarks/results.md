# Benchmarks

Inspired from the following benchmark suite: [Benchmark of popular graph/network packages](https://www.timlrx.com/2019/05/05/benchmark-of-popular-graph-network-packages/#fn).

Using 3 datasets from the [Stanford Large Network Dataset Collection](https://snap.stanford.edu/data/index.html):

* amazon, 262k nodes, 1.2m edges
* google, 875k nodes, 5.1m edges
* ~~pokec, 1.6m nodes, 30.6m edges~~ (not used yet)

## Material & methods

The following method is applied:

* Wall clock time is measured using `time`.
* Each benchmark is run 5 times, relative standard deviation is given as a measure of dispersion.
* Memory usage is measured for the whole process using `/usr/bin/time -l`.

### Software stack

The following libraries were tested on macOS 10.15.4:

* **CGL** 0.1.0 (Crystal 0.34.0)
* **igraph.cr**, raw Crystal bindings (igraph 0.8.1, Crystal 0.34.0)
* **RGL** 0.5.6 (CRuby 2.7.1)
* **python-igraph** 0.7.1 (CPython 3.7.7)
* **networkx** (CPython 3.7.7)

### Hardware

* CPU: Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz
* RAM: 16GB DDR3 @ 1600MHz

## Benchmark 1. Loading data

| Library       | Dataset | Elapsed time (s) | Memory usage |
| :------------ | :------ | :--------------- | :----------- |
| CGL           | Amazon  | 0.592s ± 0.76%   | 61.91MB      |
| igraph.cr     | Amazon  | 0.694s ± 1.29%   | 73.95MB      |
| python-igraph | Amazon  | 1.124s ± 0.49%   | 96.32MB      |
| RGL           | Amazon  | 2.616s ± 0.92%   | 117.22MB     |
| networkx      | Amazon  | 6.52s ± 1.66%    | 562.82MB     |
| CGL           | Google  | 2.658s ± 1.04%   | 205.61MB     |
| igraph.cr     | Google  | 4.13s ± 1.24%    | 295.62MB     |
| python-igraph | Google  | 4.572s ± 0.97%   | 324.17MB     |
| RGL           | Google  | 11.1s ± 1.97%    | 503.2MB      |
| networkx      | Google  | 23.676s ± 1.43%  | 2432.95MB    |
