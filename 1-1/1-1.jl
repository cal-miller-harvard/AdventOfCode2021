using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        return readdlm(f, '\n', Int32)
    end
end

function solve(input)
    count = 0
    for i in 2:length(input)
        if input[i] > input[i-1]
            count += 1
        end
    end
    return count
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
result = solve(input)
display(benchmark)
display(result)