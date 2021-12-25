using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        rows = readdlm(f, ' ', String, '\n')[:,union(1:10, 12:15)]
        return [Set(collect(rows[i,j])) for i in 1:size(rows)[1], j in 1:size(rows)[2]]
    end
end

function solve(input)
    function permutations(v)
        M = Matrix{eltype(v)}(undef, factorial(length(v)), length(v))
        return permutations!(M, v)
    end

    function permutations!(M, v)
        if length(v) == 1
            M[1,1] = v[1]
        else
            h, l = size(M)
            for i in 1:l
                M[1+(i-1)*h÷l:i*h÷l, 1] .= v[i]
                M2 = @view M[1+(i-1)*h÷l:i*h÷l, 2:l]
                permutations!(M2, [v[1:i-1]; v[i+1:l]])
            end
        end
        return M
    end
    
    segments = Dict(
        0 => [1,2,3,4,5,6],
        1 => [2,3],
        2 => [1,2,4,5,7],
        3 => [1,2,3,4,7],
        4 => [2,3,6,7],
        5 => [1,3,4,6,7],
        6 => [1,3,4,5,6,7],
        7 => [1,2,3],
        8 => [1,2,3,4,5,6,7],
        9 => [1,2,3,4,6,7]
    )

    letters = ['a','b','c','d','e','f','g']

    num2set(n, layout) = Set(letters[layout[segments[n]]])

    LUT = Dict{Set{Set{Char}}, Vector{Int32}}()
    for p in eachrow(permutations(1:7))
        k = Set([num2set(i, p) for i in 0:9])
        LUT[k] = p
    end

    count = 0
    for r in eachrow(input)
        k = Set(r[1:10])
        v = letters[LUT[k]]
        for (i,d) in enumerate(r[11:14])
            for n in 0:9
                if d == Set(v[segments[n]])
                    count += 10^(4-i) * n
                end
            end
        end
    end

    return count
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)