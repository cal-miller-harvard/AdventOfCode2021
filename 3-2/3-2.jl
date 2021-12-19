using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        data = readdlm(f, '\n', String)
        l = length(data[1])
        n = length(data)
        a = zeros(Bool, n, l)
        for i in 1:n, j in 1:l
            if data[i][j] == '1'
                a[i,j] = true
            end
        end
        return a
    end
end

mutable struct node
    zero_child::Union{node, Nothing}
    one_child::Union{node, Nothing}
    n_zero_children::Int32
    n_one_children::Int32
end

node() = node(nothing, nothing, 0,0)
function solve(input)

    function addNode(root, value)
        if value
            root.n_one_children += 1
            if isnothing(root.one_child)
                root.one_child = node()
            end
            return root.one_child
        else
            root.n_zero_children += 1
            if isnothing(root.zero_child)
                root.zero_child = node()
            end
            return root.zero_child
        end
    end

    n,l = size(input)
    root = node(nothing, nothing, 0, 0)
    for i in 1:n
        temp_root = root
        for j in 1:l
            temp_root = addNode(temp_root, input[i,j])
        end
    end
    
    n_oxy = 0
    n_co2 = 0
    root_oxy = root
    root_co2 = root
    for i in 1:l
        if root_oxy.n_one_children >= root_oxy.n_zero_children
            n_oxy += 2^(l-i)
            root_oxy = root_oxy.one_child
        else
            root_oxy = root_oxy.zero_child
        end
        if root_co2.n_one_children >= root_co2.n_zero_children > 0
            root_co2 = root_co2.zero_child
        else
            if root_co2.n_one_children > 0
                n_co2 += 2^(l-i)
                root_co2 = root_co2.one_child
            end
        end
    end
    return n_oxy*n_co2
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)