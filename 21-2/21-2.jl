using DelimitedFiles
using BenchmarkTools

struct State
    x1::Int
    x2::Int
    s1::Int
    s2::Int
    turn::Bool
end

function readInput(path)
    return [8, 5]
end

function solve(x)
    outcomes = [i+j+k for i in 1:3 for j in 1:3 for k in 1:3]
    dice = [count(x -> x==i, outcomes) for i in 1:9]

    states = Dict{State,Int}(State(x[1], x[2], 0, 0, false)=>1)
    win1 = 0
    win2 = 0
    smax = 21
    while !isempty(states)
        s, n = pop!(states)
        for roll in 3:9
            if s.turn
                x2 = mod(s.x2+roll, 1:10)
                s2 =  s.s2 + x2
                if s2 >= smax
                    win2 += n*dice[roll]
                else
                    sNew = State(s.x1, x2, s.s1, s2, false)
                    if sNew in keys(states)
                        states[sNew] += dice[roll] * n
                    else
                        states[sNew] = dice[roll] * n
                    end
                end
            else
                x1 = mod(s.x1+roll, 1:10)
                s1 =  s.s1 + x1
                if s1 >= smax
                    win1 += n*dice[roll]
                else
                    sNew = State(x1, s.x2, s1, s.s2, true)
                    if sNew in keys(states)
                        states[sNew] += dice[roll] * n
                    else
                        states[sNew] = dice[roll] * n
                    end
                end
            end
        end
    end
    return max(win1, win2)
end

input = readInput("in.txt")
# benchmark = @benchmark solve(input)
# display(benchmark)
result = solve(input)
display(result)
