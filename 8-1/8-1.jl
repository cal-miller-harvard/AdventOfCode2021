using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        rows = split.(readdlm(f, '\n', String))
        cols = [i for i in Iterators.flatten((1:10, 12:15))]
        m = Matrix{String}(undef, length(rows), length(cols))
        for (i,r) in enumerate(eachrow(m))
            r .= rows[i][cols]
            sort!(@view r[1:10])
        end
        return m
    end
end

function solve(input)
    return count(x -> length(x) in [2, 3, 4, 7], input[:, 11:14])
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)