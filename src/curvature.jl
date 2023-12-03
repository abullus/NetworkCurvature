using Graphs
using SimpleWeightedGraphs
using DataFrames

export get_edge_curvature
export get_2D_edge_curvature
export get_weighted_graph
export get_edge_curvature_distribution
export get_node_curvature_distribution

## TODO: Parallelism
function get_edge_curvature(G::SimpleGraph, e::Edge)
    return 4 - degree(G, e.src) - degree(G, e.dst)
end
get_edge_curvature(G::Graph, src::Int64, dst::Int64) = get_edge_curvature(G, Edge(src, dst))

"""
Returns the value of Forman's Ricci curvature for a given edge in a graph.

We use a modified algorithm for performance. 

``
\\mathrm{Ric}(e)= 4 - \\sqrt{w_e} \\left( \\sum_{f > u}\\frac{1}{\\sqrt{w_f}} + \\sum_{f > v} \\frac{1}{\\sqrt{w_f}} \\right)
``

"""
function get_edge_curvature(G::SimpleWeightedGraph, e::Edge)
    u = e.src
    v = e.dst
    w_e = G.weights[u, v]
    contribution = 0
    Adj_u = neighbors(G, u)
    for w in Adj_u
        contribution += 1/sqrt(G.weights[w, u])
    end
    Adj_v = neighbors(G, v)
    for w in Adj_v
        contribution += 1/sqrt(G.weights[v, w])
    end
    return 4 - sqrt(w_e)*contribution
end
get_edge_curvature(G::SimpleWeightedGraph, src::Int64, dst::Int64) = get_edge_curvature(G, Edge(src, dst))

function get_edge_curvature_distribution(G::SimpleGraph)
    return Dict(e => get_edge_curvature(G, e) for e in edges(G))
end

function get_edge_curvature_distribution(G::SimpleWeightedGraph)
    node_contributions = Dict{Int, Float64}(v => 0 for v in vertices(G))
    for v in vertices(G)
        Adj_v = neighbors(G, v)
        contribution = 0
        for u in Adj_v
            contribution += 1/sqrt(G.weights[u,v])
        end
        node_contributions[v] = contribution
    end
    curvature(e) = 4 - (sqrt(G.weights[e.src,e.dst]) * (node_contributions[e.src] + node_contributions[e.dst]))
    return Dict(e => round(curvature(e), sigdigits=4) for e in edges(G))
end

function get_node_curvature_distribution(G)
    node_curvature = Dict(vertices(G) .=> zeros(nv(G)))

    edge_curvature = get_edge_curvature_distribution(G)

    for e in edges(G)
        c = edge_curvature[e]
        node_curvature[e.src] += c
        node_curvature[e.dst] += c
    end

    return node_curvature
end