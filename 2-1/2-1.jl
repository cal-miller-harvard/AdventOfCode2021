using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        return readdlm(f, '\n', String)
    end
end

function solve(input)
    v = 0
    h = 0
    for s in input
        command, distance = split(s)
        if command == "forward"
            h += parse(Int32, distance)
        elseif  command == "up"
            v -= parse(Int32, distance)
        else
            v += parse(Int32, distance)
        end
    end
    return h*v
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
result = solve(input)
display(benchmark)
display(result)