using DelimitedFiles
using BenchmarkTools
function readInput(path)
    open(path, "r") do f
        data = readdlm(f, ' ', String, '\n')
        d = length(data[1])
        a = Matrix{Int32}(undef, d, d)
        for (i,l) in enumerate(data), j in 1:d
            a[i,j] = parse(eltype(a), l[j])
        end
        return a
    end
end

function solve(input)
    d = size(input)[1]
    risks = deepcopy(input)
    for i in 2:2*d, j in 1:i
        if 1 <= j <= d && 1 <= i - j + 1 <= d
            risks[j, i - j + 1] += min(
                j > 1 ? risks[j - 1, i - j + 1] : Inf,
                i - j + 1 > 1 ? risks[j, i - j] : Inf
            )
        end
    end
    return risks[d,d]-1
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)
