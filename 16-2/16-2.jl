using DelimitedFiles
using BenchmarkTools
function readInput(path)
    open(path, "r") do f
        l = readline(f)
        nZeros = 0
        for c in l
            if c == '0'
                nZeros += 4
            else
                break
            end
        end
        s = string(parse(BigInt, l; base=16), base=2)
        nMoreZeros = mod(length(s), 4)
        if nMoreZeros > 0
            nMoreZeros = 4 - nMoreZeros
        end
        return join([join(['0' for _ in 1:nZeros+nMoreZeros]), s])
    end
end

function solve(input)
    function parsePacket(p)
        type = parse(Int, p[4:6]; base=2)
        if type == 4
            s = ""
            i = 7
            while true
                s *= p[i+1:i+4]
                if p[i] == '1'
                    i += 5
                else
                    break
                end
            end
            remainder = p[i+5:end]
            if all(i -> i=='0', remainder)
                remainder = ""
            end
            return (parse(Int, s; base=2), remainder)
        else
            length_type = p[7]
            if length_type == '0'
                nBits = parse(Int, p[8:8+14]; base=2)
                subpackets = p[8+14+1:8+14+nBits]
                remainder = p[8+14+nBits+1:end]
                if all(i -> i=='0', remainder)
                    remainder = ""
                end
                parsedSubpackets = []
                while subpackets != ""
                    p, subpackets = parsePacket(subpackets)
                    push!(parsedSubpackets, p)
                end
            else
                nPackets = parse(Int, p[8:8+10]; base=2)
                subpackets = p[8+10+1:end]
                parsedSubpackets = []
                for i in 1:nPackets
                    p, subpackets = parsePacket(subpackets)
                    push!(parsedSubpackets, p)
                end
                remainder = subpackets
                if all(i -> i=='0', remainder)
                    remainder = ""
                end
            end
            if type == 0
                return (sum(parsedSubpackets), remainder)
            elseif type == 1
                return (prod(parsedSubpackets), remainder)
            elseif type == 2
                return (minimum(parsedSubpackets), remainder)
            elseif type == 3
                return (maximum(parsedSubpackets), remainder)
            elseif type == 5
                return (parsedSubpackets[1] > parsedSubpackets[2], remainder)
            elseif type == 6
                return (parsedSubpackets[1] < parsedSubpackets[2], remainder)
            elseif type == 7
                return (parsedSubpackets[1] == parsedSubpackets[2], remainder)
            else
                return (NaN, remainder)
            end
        end
    end
    
    getVersion(t::Tuple) = t[1] + sum(append!([0],[getVersion(a) for a in t if isa(a, Vector)]))
    getVersion(a::Vector) = sum(getVersion(i) for i in a)

    return parsePacket(input)[1]
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)
