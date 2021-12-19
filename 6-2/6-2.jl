using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        return readdlm(f, ',', Int64)[:]
    end
end

function solve(input)
    state = zeros(Int64, 9)
    temp = deepcopy(state)

    for i in 0:8
        state[i+1] = count(x -> x == i, input)
    end

    function update!(state)
        circshift!(temp, state, -1)
        temp[7] += state[1]
        state .= temp
    end

    for _ in 1:256
        update!(state)
    end

    return sum(state)
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)