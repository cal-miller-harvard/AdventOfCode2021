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
    n = 5
    d1 = size(input)[1]
    d = n*d1
    risks = Matrix{Int32}(undef, d, d)
    display(risks)
    for i in 1:n, j in 1:n
        risks[1 + d1*(i-1):d1*i, 1 + d1*(j-1):d1*j] .= map(x -> mod(x .+ (i + j - 2), 1:9), input)
    end
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
# benchmark = @benchmark solve(input)
# display(benchmark)
result = solve(input)
display(result)
