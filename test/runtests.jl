using Test
using Graphs
using SimpleWeightedGraphs

include("../src/NetworkCurvature.jl")
using .NetworkCurvature

const testdir = dirname(@__FILE__)

tests = [
    "curvature"
]

@testset "NetworkCurvature" begin
    for t in tests
        tp = joinpath(testdir, "$(t).jl")
        include(tp)
    end
end