using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        data = collect.(readdlm(f, '\n', String))
        w = length(data[1])
        h = length(data)
        M = 10 .* ones(Int16, h, w)
        for i in 1:h, j in 1:w
            M[i,j] = parse(eltype(M), data[i][j])
        end
        return M
    end
end

function solve(input)
    function step!(state)
        flashes = 0
        h,w = size(state)
        state .+= 1
        queue = [[i,j] for i in 1:h for j in 1:w]
        flashed = []
        deltas = [[-1,-1], [-1,0], [-1,1], [0,-1], [0,1], [1,-1], [1,0], [1,1]]
        while length(queue) > 0
            i,j = pop!(queue)
            if state[i,j] > 9
                push!(flashed, [i,j])
                flashes += 1
                state[i,j] = 0
                for delta in deltas
                    dy, dx = delta
                    if (0 < i + dy <= h) && (0 < j + dx <= w)
                        state[i + dy, j + dx] += 1
                        push!(queue, [i + dy, j + dx])
                    end
                end
            end
        end
        while length(flashed) > 0
            i,j = pop!(flashed)
            state[i,j] = 0
        end
        return flashes
    end

    state = deepcopy(input)
    flashes = 0
    t = 0
    while true
        t += 1
        if step!(state) == length(state)
            return t
        end
    end
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)