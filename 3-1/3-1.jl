using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        return readdlm(f, '\n', String)
    end
end

function solve(input)
    l = length(input[1])
    n = length(input)
    counts = zeros(Int32, l)
    for s in input, i in 1:l
        if s[i] == '1'
            counts[i] += 1
        end
    end
    gamma = 0
    epsilon = 0
    for i in 1:l
        if counts[i] > n/2
            gamma += 2^(l-i)
        else
            epsilon += 2^(l-i)
        end
    end
    return gamma*epsilon
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
result = solve(input)
display(benchmark)
display(result)