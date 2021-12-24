using DelimitedFiles
using BenchmarkTools
function readInput(path)
    return [56, -162, 76, -134]
end

function solve(input)
    xmin = input[1]
    ymin = input[2]
    xmax = input[3]
    ymax = input[4]

    function step(x, y, vx, vy)
        x += vx
        y += vy
        vx -= sign(vx)
        vy -= 1
        return (x, y, vx, vy)
    end

    function simulate(vx, vy, xmin, ymin, xmax, ymax)
        x = 0
        y = 0
        hmax = 0
        while vy >= 0 || y > ymin
            x, y, vx, vy = step(x, y, vx, vy)
            hmax = max(y, hmax)
            if xmin <= x <= xmax && ymin <= y <= ymax
                return hmax
            end
        end
        return 0
    end

    return maximum([simulate(vx, vy, xmin, ymin, xmax, ymax) for vx in 1:500, vy in -1000:1000])
end

input = readInput("in.txt")
# benchmark = @benchmark solve(input)
# display(benchmark)
result = solve(input)
display(result)
