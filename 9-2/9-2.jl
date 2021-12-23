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
    sizes = []
    for i in 2:h-1, j in 2:w-1
        if (input[i,j] < input[i+1,j] && input[i,j] < input[i,j+1] && input[i,j] < input[i-1,j] && input[i,j] < input[i,j-1])
            basin = Set{Tuple}([(i,j)])
            last_size = 0
            while length(basin) != last_size
                last_size = length(basin)
                for (k,l) in basin
                    if input[k-1,l] < 9
                        push!(basin, (k-1,l))
                    end
                    if input[k+1,l] < 9
                        push!(basin, (k+1,l))
                    end
                    if input[k,l-1] < 9
                        push!(basin, (k,l-1))
                    end
                    if input[k,l+1] < 9
                        push!(basin, (k,l+1))
                    end
                end
            end
            push!(sizes, length(basin))
        end
    end
    return prod(sort!(sizes)[end-2:end])
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)