# julia-network-curvature-analysis

## Overview

This works builds on the _Graphs.jl_ package for Julia.

For my dissertation, I studied Forman's discretisation of Ricci curvature. As a result, I have implemented algorithms for computing this measure in Julia. 

During this work I also studied Forman's curvature on weighted graphs. The _GraphIO_ package does not implement I/O for weighted graphs. Therefore, also included in this repository are methods for I/O of graphs with edge weights for the EdgeList format. 

## Forman's discretisation

For graphs with edge weights, Forman's Ricci curvature is an edge based notion given by the following formula
$$
\mathrm{Ric}(e) = 2 - \sqrt{w_e} \left( \sum_{f > u, \ f \neq e}\frac{1}{\sqrt{w_f}} + \sum_{f > v, \ f \neq e} \frac{1}{\sqrt{w_f}} \right)
$$
where $f>u$ refers to an edge $f$ that is connected to vertex $u$, and $w_e$ is the weight of edge $e$. For graphs that are unweighted (so with edge weight $1$), this formula simplifies to
$$
\mathrm{Ric}(e) = 2- \mathrm{deg}(u) - \mathrm{deg}(v) 
$$
for an edge $e$ with endpoints $u$ and $v$.

We define the curvature of a vertex $v$ to be 
$$
\mathrm{Ric}(v) = \sum_{e \sim v} \mathrm(Ric)(e)
$$
where the sum is taken over all edges adjacent to vertex $v$. 

Functions implementing the above can be found in `src/curvature.jl` 

## I/O

The _GraphIO_ package does not extend to weighted graphs. The _Graphs.jl_ package has been extended to weighted graphs with the package _SimpleWeightedGraphs_. However, this package does not include I/O. As a result, to progress my project, I had to write functions for this. 

These functions can be found in `src/persistence.jl`

## Demonstrations

For my project, I compared curvature to other network statistics. The source code for this work can be found in the `demos` folder. There are three real world networks included:
| Name | Number of vertices | Number of edges | Type |
| --- | --- | --- | --- |
| Astrophysics | 18 772 | 198 110 | Unweighted |
| bio-WormNet-v3 | 16 347 | 762 822 | Weighted |
| cond-mad-2003 |30 460 | 120 029 | Weighted |

## Multi-Threading

For performance, several algorithms allow for parallelism. To take advantage of this behaviour, Julia must be started with more than one thread. 

To start Julia with `n` threads:
```bash
$ julia --threads n
```

