@testset "Curvature" begin
    G = SimpleGraph(6)
    add_edge!(G, 1, 2); add_edge!(G, 3, 4); add_edge!(G, 4, 5); add_edge!(G, 5, 6); add_edge!(G, 4, 6)
    W = SimpleWeightedGraph(7)
    add_edge!(W, 1, 2, 4); add_edge!(W, 3, 4, 9); add_edge!(W, 4, 5, 4); add_edge!(W, 3, 5, 4); 
    add_edge!(W, 5, 6, 16); add_edge!(W, 6, 7, 1); 
    @testset "Edge curvature" begin
        @test get_edge_curvature(G, 1, 2) == 2

        @test get_edge_curvature_distribution(G) == Dict{Graphs.SimpleGraphs.SimpleEdge{Int64}, Int64}(
            Edge(1, 2) => 2,
            Edge(3, 4) => 0,
            Edge(4, 5) => -1,
            Edge(4, 6) => -1,
            Edge(5, 6) => 0,
        )

        @test round(get_edge_curvature(W, 3, 5), sigdigits=4) == round(-1/6, sigdigits=4)

        @test get_edge_curvature_distribution(W) ==  Dict{SimpleWeightedEdge{Int64, Float64}, Float64}(
            SimpleWeightedEdge(5,6,16.0) => -6.0,
            SimpleWeightedEdge(3,4,9.0) => -1.0,
            SimpleWeightedEdge(3,5,4.0) => round(-1/6, sigdigits=4),
            SimpleWeightedEdge(1,2,4.0) => 2.0,
            SimpleWeightedEdge(6,7,1.0) => 1.75,
            SimpleWeightedEdge(4,5,4.0) => round(-1/6, sigdigits=4)
            )
    end
end