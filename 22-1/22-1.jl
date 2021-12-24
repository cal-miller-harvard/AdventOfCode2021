using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        lines = map(x -> split(x, ['.','=',' ',',']), readdlm(f, '\n', String))
        return [(
            l[1] == "on" ? true : false,
            parse(Int,l[3]):parse(Int,l[5]),
            parse(Int,l[7]):parse(Int,l[9]),
            parse(Int,l[11]):parse(Int,l[13]),
        ) for l in lines]
    end
end

function solve(input)
    d = 50
    r = zeros(Bool, 2d+1, 2d+1, 2d+1)
    for i in input
        xrange = intersect(-d:d, i[2]) .+ 51
        yrange = intersect(-d:d, i[3]) .+ 51
        zrange = intersect(-d:d, i[4]) .+ 51
        r[xrange, yrange, zrange] .= i[1]
    end
    return sum(r)
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)
