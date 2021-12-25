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

    max_cost = 5000
    queue = [Set{Tuple{Int, Int}}() for _ in 1:max_cost]
    push!(queue[1], (1,1))
    
    costs = max_cost .* ones(Int32, d, d)
    costs[1,1] = 1

    risks = Matrix{Int32}(undef, d, d)
    for i in 1:n, j in 1:n
        risks[1 + d1*(i-1):d1*i, 1 + d1*(j-1):d1*j] .= map(x -> mod(x .+ (i + j - 2), 1:9), input)
    end

    function insert(v, d)
        push!(queue[d], (v[1], v[2]))
        costs[v[1], v[2]] = d
    end

    function decreaseKey(v, d)
        delete!(queue[costs[v[1], v[2]]], v)
        insert(v, d)
    end

    queueMin = 1
    function extractMin()
        while isempty(queue[queueMin])
            queueMin += 1
            if queueMin > length(queue)
                return nothing
            end
        end
        return pop!(queue[queueMin])
    end

    inQueue(v) = v in queue[costs[v[1], v[2]]]

    function neighbors(i,j)
        l = Set{Tuple{Int, Int}}()
        if i > 1
            push!(l, (i-1, j))
        end
        if j > 1
            push!(l, (i, j-1))
        end
        if i < d
            push!(l, (i+1, j))
        end
        if j < d
            push!(l, (i, j+1))
        end
        return l
    end

    n = extractMin()
    while !isnothing(n)
        i,j = n
        for neighbor in neighbors(i,j)
            i2, j2 = neighbor
            c = costs[i,j] + risks[i2, j2]
            if costs[i2, j2] > c
                if inQueue(neighbor)
                    decreaseKey(neighbor, c)
                else
                    insert(neighbor, c)
                end
            end
        end
        n = extractMin()
    end
    
    return costs[end, end] - 1
end

input = readInput("in.txt")
# benchmark = @benchmark solve(input)
# display(benchmark)
result = solve(input)
display(result)
