using DelimitedFiles
using BenchmarkTools

mutable struct Node
    name::String
    neighbors::Set{Node}
    big::Bool
end

Node(name) = Node(name, Set{Node}(), isuppercase(name[1]))

function readInput(path)
    open(path, "r") do f
        data = readdlm(f, '\n', String)
        n = length(data)
        edges = Array{String}(undef, n, 2)
        nodes = Dict{String, Node}()
        for i in 1:n
            n1, n2 = split(data[i], '-')
            if !(n1 in keys(nodes))
                nodes[n1] = Node(n1)
            end
            if !(n2 in keys(nodes))
                nodes[n2] = Node(n2)
            end
            push!(nodes[n1].neighbors, nodes[n2])
            push!(nodes[n2].neighbors, nodes[n1])
        end
        return nodes
    end
end

function solve(nodes)
    function canAdd(n, path)
        if !(n in path) || n.big
            return true
        elseif n.name == "start" || n.name == "end"
            return false
        else
            ok = true
            for m in unique(path)
                if !m.big && count(x -> x==m, path) > 1
                    ok = false
                end
            end
            return ok
        end
    end

    paths = 0
    stack = [nodes["start"]]
    path = []
    while length(stack) > 0
        head = pop!(stack)
        if head.name == "end"
            paths += 1
            # display(append!([n.name for n in path],["end"]))
        elseif length(path) > 0 && head == path[end]
            pop!(path)
        else
            push!(stack, head)
            push!(path, head)
            for n in head.neighbors
                if canAdd(n, path)
                    push!(stack, n)
                end
            end
        end
    end
    return paths
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)