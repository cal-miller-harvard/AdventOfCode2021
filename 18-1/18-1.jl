using DelimitedFiles
using BenchmarkTools

struct SnailNumber
    x::String
end

Base.:+(x::SnailNumber, y::SnailNumber) = SnailNumber(join(["[",x.x,",",y.x,"]"]))

function magnitude(n::SnailNumber)
    n = n.x
    re = r"\[(\d+),(\d+)\]"
    foo(m) = 3*parse(Int,m[1]) + 2*parse(Int,m[2])
    while occursin(re, n)
        n = replace(n, re => s -> foo(match(re, s)))
    end
    return(parse(Int, n))
end

function reduce(n::SnailNumber)
    n = n.x
    d = 0
    left = true
    i = 1
    check_explosions = true
    check_splits = false
    while i <= length(n)
        if n[i] == '['
            d += 1
            i += 1
        elseif n[i] == ']'
            d -= 1
            i += 1
        elseif n[i] == ','
            left = !left
            i += 1
        else
            v = 0
            i0 = i
            while 0 <= (digit = n[i]-'0') < 10
                v = 10*v + digit
                i += 1
            end
            if check_explosions && d > 4 && n[i0-1] == ',' && 0 <= (n[i0-2]-'0') < 10
                v2 = 0
                j = i0-2
                while 0 <= (digit = n[j]-'0') < 10
                    v2 += digit * 10^(i0-2-j)
                    j -= 1
                end
                n = join([n[1:j-1],0,n[i+1:end]])
                i = findnext(x -> 0 <= (x-'0') < 10, n, j+2)
                if !isnothing(i)
                    v3 = 0
                    i0 = i    
                    while 0 <= (digit = n[i]-'0') < 10
                        v3 = 10*v3 + digit
                        i += 1
                    end
                    v3 += v
                    n = join([n[1:i0-1],v3,n[i:end]])
                end
                j = findprev(x -> 0 <= (x-'0') < 10, n, j-1)
                if !isnothing(j)
                    v3 = 0
                    i = j
                    while 0 <= (digit = n[j]-'0') < 10
                        v3 += digit * 10^(i-j)
                        j -= 1
                    end
                    v3 += v2
                    n = join([n[1:j],v3,n[i+1:end]])
                end
                i = 1
                d = 0
            end
            if check_splits && v > 9
                n = join([n[1:i0-1],"[",fld(v,2),",",cld(v,2),"]",n[i:end]])
                i = 1
                d = 0
                check_splits = false
                check_explosions = true
            end
        end
        if i == length(n) && check_explosions
            i = 1
            d = 0
            check_explosions = false
            check_splits = true
        end
    end
    return SnailNumber(n)
end

function readInput(path)
    open(path, "r") do f
        return map(SnailNumber, readdlm(f, ' ', String, '\n'))
    end
end

function solve(input)
    n = input[1]
    for i in input[2:end]
        n = reduce(n + i)
    end
    return magnitude(n)
end

input = readInput("in.txt")
# benchmark = @benchmark solve(input)
# display(benchmark)
result = solve(input)
display(result)
