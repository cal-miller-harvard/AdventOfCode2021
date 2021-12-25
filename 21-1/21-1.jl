using DelimitedFiles
using BenchmarkTools

function readInput(path)
    return [8, 5]
end

function solve(x)
    roll_count = 0

    function roll()
        roll_count += 1
        return mod(roll_count, 1:100)
    end

    scores = [0, 0]
    while true
        for p in 1:2
            x[p] = mod(x[p] + sum(roll() for _ in 1:3), 1:10)
            # println(x)
            scores[p] += x[p]
            if scores[p] >= 1000
                return scores[mod(p+1,1:2)]*roll_count
            end
        end
    end
end

input = readInput("in.txt")
# benchmark = @benchmark solve(input)
# display(benchmark)
result = solve(input)
display(result)
