using Graphs, SimpleWeightedGraphs, Random

# Based on the GraphIO testing implementation

unweighted = Dict{String,Graph}(
    "unweighted1"    => complete_graph(5), 
    "unweighted2"    => path_graph(6),
    "unweighted3"    => wheel_graph(5)
    )

function add_weight(G)
    W = SimpleWeightedGraph(nv(G))
    r = randexp(ne(G))
    for (i, e) in enumerate(edges(G))
        SimpleWeightedGraphs.add_edge!(W, SimpleWeightedEdge(e.src, e.dst, r[i]))
    end
    return W
end

weighted = Dict{String,SimpleWeightedGraph}(
    "weighted1"   => add_weight(complete_graph(5)), 
    "weighted2"   => add_weight(path_graph(6)),
    "weighted3"   => add_weight(wheel_graph(4))
)

graphs = merge(unweighted, weighted)

function temp_file_name()
    (path, io) = mktemp()
    close(io)
    return path
end

function test_one_graph(G, filepath)
    @test save_graph_as_edgelist(G, filepath) == 1
    @test load_graph_from_edgelist(filepath) == G
    rm(filepath)
end

@testset "Persistence" begin
    for G in values(graphs)
        test_one_graph(G, temp_file_name())
    end
end