using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        data = collect.(readdlm(f, '\n', String))
        return data
    end
end

function solve(input)
    opens = ['{', '[', '<', '(']
    closes = ['}', ']', '>', ')']
    scores = [3, 2, 4, 1]
    lineScores = []
    for l in input
        score = 0
        stack = Vector{Char}()
        lineOK = true
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
                lineOK = false
                break
            end
        end
        while lineOK && length(stack) > 0
            c = pop!(stack)
            score = 5*score + scores[indexin(c,opens)][1]
        end
        if lineOK 
            push!(lineScores, score)
        end
    end
    return sort!(lineScores)[length(lineScores)÷2 + 1]
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)