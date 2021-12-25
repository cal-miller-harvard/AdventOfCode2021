using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        data = readdlm(f,' ', String, '\n')
        template = collect(data[1,1])
        n_rules = size(data)[1]-1
        rules = Dict{Tuple{Char, Char},Char}()
        for i in 1:n_rules
            rules[(data[i+1,1][1], data[i+1,1][2])] = data[i+1,3][1]
        end
        return template, rules
    end
end

function solve(input)
    template, rules = input

    counts = Dict{Char, Int}()
    for c in values(rules)
        counts[c] = 0
    end
    for c in template
        counts[c] += 1
    end

    pairs = Dict{Tuple{Char, Char},Int}()
    for i in 1:length(template)-1
        c,d = template[[i, i+1]]
        if (c,d) in keys(pairs)
            pairs[(c, d)] += 1
        else
            pairs[(c,d)] = 1
        end
    end

    function update()
        newPairs = Dict{Tuple{Char, Char},Int}()
        for (k,v) in pairs
            if k in keys(rules)
                c = rules[k]
                counts[c] += v
                pairs[k] = 0
                for p in [(k[1], c), (c, k[2])]
                    if p in keys(newPairs)
                        newPairs[p] += v
                    else
                        newPairs[p] = v
                    end
                end
            end
        end
        return newPairs
    end

    for _ in 1:40
        pairs = update()
    end
    

    cVals = values(counts)
    return maximum(cVals) - minimum(cVals)
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)