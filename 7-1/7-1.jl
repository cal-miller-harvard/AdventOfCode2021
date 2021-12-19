using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        return readdlm(f, ',', Int32)[:]
    end
end

function solve(input)
    cost(x) = sum(abs.(input .- x))
    return minimum(cost, minimum(input):maximum(input))
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)