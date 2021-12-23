using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        data = collect.(readdlm(f, '\n', String))
        return data
    end
end

function solve(input)
    score = 0
    opens = ['{', '[', '<', '(']
    closes = ['}', ']', '>', ')']
    scores = [1197, 57, 25137, 3]
    for l in input
        stack = Vector{Char}()
        for c in l
            OK = false
            if c in opens
                push!(stack, c)
                OK = true
            else
                for (i, close) in enumerate(closes)
                    if c == close && stack[end] == opens[i]
                        pop!(stack)
                        OK = true
                    end
                end
            end
            if !OK && length(stack) > 0
                score += scores[indexin(c,closes)][1]
                break
            end
        end
    end
    return score
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)