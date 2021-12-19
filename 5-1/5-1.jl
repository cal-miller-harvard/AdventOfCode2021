using DelimitedFiles
using BenchmarkTools
using SparseArrays

function readInput(path)
    open(path, "r") do f
        data = readdlm(f, '\n', String)
        n = length(data)
        a = Array{Int32}(undef, n, 4)
        for i in 1:n
            row = split(data[i], [' ', ','])[[1,2,4,5]]
            a[i,:] .= parse.(Int32, row)
        end
        return a
    end
end

function solve(input)
    rows = [i for i in 1:size(input)[1] if input[i, 1] == input[i, 3] || input[i, 2] == input[i, 4]]
    lines = input[rows,:] .+ 1

    dy = maximum(lines[:,[2,4]])
    dx = maximum(lines[:,[1,3]])
    points = spzeros(Int32, dy, dx)

    for i in 1:size(lines)[1]
        x0, y0, x1, y1 = @view lines[i,:]
        if x1 == x0
            points[y0:(y0 < y1 ? 1 : -1):y1, x0] .+= 1
        else
            slope = (y1 - y0) // (x1 - x0)
            for x in x0:(x0 < x1 ? 1 : -1):x1
                points[y0 + convert(Int32, slope*(x-x0)), x] += 1
            end
        end
    end

    return count(x -> x > 1, points.nzval)
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)