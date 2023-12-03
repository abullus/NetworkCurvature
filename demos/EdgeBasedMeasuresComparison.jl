using Graphs, DataFrames
using Base.Threads

include("../src/NetworkCurvature.jl")
using .NetworkCurvature

function get_embeddedness(G, e)
    Adj_u = neighbors(G, e.src)
    Adj_v = neighbors(G, e.dst)
    return length(intersect(Adj_u, Adj_v))
end

function export_data(filename)
    G = load_graph_from_edgelist(filename)

    weighted = typeof(G) !== SimpleGraph{Int}

    curvature_dist = get_edge_curvature_distribution(G)

    source = Int[]
    destination = Int[]
    weight = Float64[]
    curvature = Float64[]
    embeddedness = Int[]

    for e in edges(G)
        push!(source, e.src)
        push!(destination, e.dst)
        if weighted
            push!(weight, e.weight)
        end
        push!(curvature, curvature_dist[e])
        push!(embeddedness, get_embeddedness(G, e))
    end

    df = DataFrame()
    df.Source = source
    df.Destination = destination
    if weighted
        df.Weighted = weight
    end
    df.Edge_Curvature = curvature
    df.Embeddedness = embeddedness

    export_data_frame_to_csv(df, filename*"-EdgeData.csv")
end

datasets = [
    "bio-WormNet-v3.edges",
    "cond-mat-2003.txt",
    "Astrophysics.txt"
]

for dataset in datasets
    export_data("datasets/"*dataset)
end