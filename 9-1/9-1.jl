using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        data = collect.(readdlm(f, '\n', String))
        w = length(data[1])
        h = length(data)
        M = 10 .* ones(Int16, h+2, w+2)
        for i in 1:h, j in 1:w
            M[i+1,j+1] = parse(eltype(M), data[i][j])
        end
        return M
    end
end

function solve(input)
    h, w = size(input)
    risk = 0
    for i in 2:h-1, j in 2:w-1
        risk += (input[i,j] < input[i+1,j] && input[i,j] < input[i,j+1] && input[i,j] < input[i-1,j] && input[i,j] < input[i,j-1]) ? input[i,j] + 1 : 0
    end
    return risk
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)