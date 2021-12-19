using DelimitedFiles
using BenchmarkTools

function readInput(path)
    sortstr(s) = join(sort!(collect(s)))

    open(path, "r") do f
        rows = split.(readdlm(f, '\n', String))
        cols = [i for i in Iterators.flatten((1:10, 12:15))]
        m = Matrix{String}(undef, length(rows), length(cols))
        for (i,r) in enumerate(eachrow(m))
            r .= map(sortstr, rows[i][cols])
            sort!(@view r[1:10])
        end
        return m
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
        9 => [1,2,3,6,7]
    )

    letters = ['a','b','c','d','e','f','g']

    num2str(n, layout) = join(sort!(letters[layout[segments[n]]]))

    LUT = Dict{Vector{String}, Vector{Int32}}()
    for p in eachrow(permutations(1:7))
        k = sort!([num2str(i, p) for i in 0:9])
        LUT[k] = p
    end

    for l in eachrow(input)
        p = LUT[@view l[1:10]]
        display(p)
    end
end

input = readInput("in.txt")
# benchmark = @benchmark solve(input)
# display(benchmark)
result = solve(input)
display(result)