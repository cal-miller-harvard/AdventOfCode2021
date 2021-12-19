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
    aim = 0
    for s in input
        command, distance = split(s)
        distance = parse(Int32, distance)
        if command == "forward"
            h += distance
            v += distance * aim
        elseif  command == "up"
            aim -= distance
        else
            aim += distance
        end
    end
    return h*v
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
result = solve(input)
display(benchmark)
display(result)