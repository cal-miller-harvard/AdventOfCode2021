using DelimitedFiles
using BenchmarkTools
import Base.length
import Base.intersect

struct Region
    x::UnitRange{Int64}
    y::UnitRange{Int64}
    z::UnitRange{Int64}
    on::Bool
end

length(r::Region) = length(r.x)*length(r.y)*length(r.z)*(r.on ? 1 : -1)

function intersect(q::Region, r::Region)
    x = intersect(q.x, r.x)
    y = intersect(q.y, r.y)
    z = intersect(q.z, r.z)
    if length(x) == 0 || length(y) == 0 || length(z) == 0
        return nothing
    elseif !q.on && !r.on
        return Region(x, y, z, true)
    elseif q.on && r.on
        return Region(x, y, z, false)
    elseif q.on && !r.on
        return Region(x, y, z, true)
    elseif !q.on && r.on
        return Region(x, y, z, false)
    end
end

function readInput(path)
    open(path, "r") do f
        lines = map(x -> split(x, ['.','=',' ',',']), readdlm(f, '\n', String))
        return [Region(
            parse(Int,l[3]):parse(Int,l[5]),
            parse(Int,l[7]):parse(Int,l[9]),
            parse(Int,l[11]):parse(Int,l[13]),
            l[1] == "on" ? true : false
        ) for l in lines]
    end
end

function solve(input)
    regions = Vector{Region}()
    for q in input
        l = length(regions)
        for i in 1:l
            s = intersect(q, regions[i])
            if !isnothing(s)
                push!(regions, s)
            end
        end
        if q.on
            push!(regions, q)
        end
    end
    return sum(length.(regions))
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)
