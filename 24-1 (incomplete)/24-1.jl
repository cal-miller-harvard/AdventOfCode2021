using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        return readdlm(f, ' ', String)
    end
end

function solve(program)
    @inbounds @fastmath function ALU(inputs)
        inputs = reverse(inputs)
        regs = Dict("w"=>0, "x"=>0, "y"=>0, "z"=>0)
        k = keys(regs)
        for l in eachrow(program)
            if l[1] == "inp"
                regs[l[2]] = pop!(inputs)
            elseif l[1] == "add"
                regs[l[2]] += l[3] in k ? regs[l[3]] : parse(Int, l[3])
            elseif l[1] == "mul"
                regs[l[2]] *= l[3] in k ? regs[l[3]] : parse(Int, l[3])
            elseif l[1] == "div"
                regs[l[2]] ÷= l[3] in k ? regs[l[3]] : parse(Int, l[3])
            elseif l[1] == "mod"
                regs[l[2]] = mod(regs[l[2]], l[3] in k ? regs[l[3]] : parse(Int, l[3]))
            elseif l[1] == "eql"
                regs[l[2]] = regs[l[2]] == (l[3] in k ? regs[l[3]] : parse(Int, l[3]))
            end
        end
        return regs
    end

    digits = 14
    n0 = [9 for _ in 1:digits]
    while ALU(n0)["z"] != 0
        for i in digits:-1:1
            if n0[i] > 1
                n0[i] -= 1
                n0[i+1:end] .= 9
                break
            end
        end
        break
    end
    display(@code_native ALU(n0))
    return n0
end

input = readInput("in.txt")
# benchmark = @benchmark solve(input)
# display(benchmark)
result = solve(input)
display(result)
