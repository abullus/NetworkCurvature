using Graphs
using SimpleWeightedGraphs
using CSV
using DataFrames
using DelimitedFiles

export load_graph_from_edgelist
export save_graph_as_edgelist
export export_data_frame_to_csv


function export_data_frame_to_csv(dataframe, filename)
    CSV.write(filename, dataframe)
end


"""
Load a weighted graph in edge list format.

Fork of loadedgelist from GraphIO. String splitting is used as in 
the Python NetworkX implementation of the same feature.

"""
function load_graph_from_edgelist(filepath, dlm=isspace)
    println("Begin read...")
    open(filepath, "r") do io
        srcs = Vector{String}()
        dsts = Vector{String}()
        wghts = Vector{Float64}()
        weighted_flag = false
        while !eof(io)
            line = strip(chomp(readline(io)))
            if !startswith(line, "#") && (line != "")
                line = split(line, dlm)
                src_s, dst_s = line[1], line[2]
                if length(line) == 2 
                    wght_s = 1
                else 
                    wght_s = parse(Float64, line[3])
                    if wght_s != 1
                        weighted_flag = true 
                    end
                end
                push!(srcs, src_s)
                push!(dsts, dst_s)
                push!(wghts, wght_s)
            end
        end
        vxset = unique(vcat(srcs, dsts))
        vxdict = Dict{String,Int}()
        for (v, k) in enumerate(vxset)
            vxdict[k] = v
        end
        
        n_v = length(vxset)
        if weighted_flag == true
            G = SimpleWeightedGraphs.SimpleWeightedGraph(n_v)
            for (u, v, w) in zip(srcs, dsts, wghts)
                add_edge!(G, vxdict[u], vxdict[v], w) 
            end
        else
            G = Graphs.Graph(n_v)
            for (u, v) in zip(srcs, dsts)
                add_edge!(G, vxdict[u], vxdict[v]) 
            end
        end
        return G
    end
end

function save_graph_as_edgelist(G::SimpleGraph, filepath)
    open(filepath, "w") do io
        writedlm(io, ([e.src, e.dst] for e in edges(G)))
    end
    return true
end

function save_graph_as_edgelist(G::SimpleWeightedGraph, filepath)
    open(filepath, "w") do io
        writedlm(io, ([e.src, e.dst, e.weight] for e in edges(G)))
    end
    return true
end
