using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        data = readdlm(f, ',', String, '\n')
        nFolds = count(x -> x=="", data[:,2])
        nPoints = size(data)[1] - nFolds
        points = Set{Vector{Int32}}()
        folds = Matrix{Int32}(undef, nFolds, 2)
        for i in 1:nPoints
            push!(points, parse.(Int32, data[i,:]))
        end
        for i in 1:nFolds
            if 'x' in data[i+nPoints,1]
                folds[i,1] = parse(eltype(folds), split(data[i+nPoints,1],'=')[2])
                folds[i,2] = 0
            else
                folds[i,2] = parse(eltype(folds), split(data[i+nPoints,1],'=')[2])
                folds[i,1] = 0
            end
        end
        return points, folds
    end
end

function solve(input)
    points, folds = input

    function fold!(points, fold)
        if fold[1] > 0
            for p in points
                if p[1] > fold[1]
                    push!(points, [2 * fold[1] - p[1], p[2]])
                    delete!(points, p)
                end
            end
        else
            for p in points
                if p[2] > fold[2]
                    push!(points, [p[1], 2 * fold[2] - p[2]])
                    delete!(points, p)
                end
            end
        end
        return points
    end

    fold!(points, folds[1,:])

    return length(points)
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)