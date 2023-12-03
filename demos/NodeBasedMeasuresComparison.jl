using Graphs, DataFrames
import Graphs.Parallel

include("../src/NetworkCurvature.jl")
using .NetworkCurvature

# Computations are rounded to save storage space
round_vec(vec, sigdigits=4) = [round.(x, sigdigits=sigdigits) for x in vec]

function export_data(filename)
    G = loadedgelist_weighted(filename)

    # Computationally intensive calculations are done here so that progress can be tracked.
    # The final calculations were too intensive for most networks.
    println("Node curvature...")
    curvature_dist = get_node_curvature_distribution(G)
    println("Betweenness...")
    betweenness = round_vec(Parallel.betweenness_centrality(G, min(nv(G), 100)))
    println("Pagerank...")
    pagerank = round_vec(Parallel.pagerank(G))
    println("LCC...")
    lcc = round_vec(local_clustering_coefficient(G))
    println("Eigenvector centrality...")
    eig_cen = round_vec(eigenvector_centrality(G))
    println("Closeness centrality...")
    closeness = round_vec(closeness_centrality(G))
    println("Katz centrality...")
    katz = round_vec(katz_centrality(G))

    df = DataFrame()
    df.Node = [v for v in vertices(G)]
    df.Degree = degree(G)
    df.Node_Curvature = [curvature_dist[v] for v in vertices(G)]
    df.Triangles = triangles(G)
    df.Betweenness_Centrality = betweenness
    df.Pagerank = pagerank
    df.Local_Clustering_Coefficient = lcc
    df.Eigenvector_Centrality = eig_cen
    df.Closeness_Centrality = closeness
    df.Katz_Centrality = katz
        

    export_data_frame_to_csv(df, filename*"-NodeData.csv")
end

datasets = [
    "bio-WormNet-v3.edges",
    "cond-mat-2003.txt",
    "Astrophysics.txt"
]

for dataset in datasets
    export_data("datasets/"*dataset)
end