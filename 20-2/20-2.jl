using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        lines = readdlm(f, '\n', String)
        algorithm = [c == '#' for c in lines[1]]
        x = 1:length(lines[2])
        y = 1:length(lines) - 1
        image = [(lines[i+1][j] == '#') for i in y, j in x]
        return (algorithm, image)
    end
end

function solve(input)
    algorithm, image = input

    function expand(image, bg=false)
        x, y = size(image)
        a = bg .+ zeros(eltype(image), x + 4, y + 4)
        a[3:2+y, 3:2+x] .= image
        return a
    end

    function crop(image, bg)
        if bg
            image .= .!image
        end
        rows = [sum(r) > 0 for r in eachrow(image)]
        cols = [sum(c) > 0 for c in eachcol(image)]
        return @view image[
            findfirst(rows):findlast(rows),
            findfirst(cols):findlast(cols)]
    end

    function enhance(img, algorithm, bg)
        img = expand(img, bg)
        x, y = size(img) .- 2
        img2 = Matrix{Bool}(undef, x, y)
        for i in 1:y, j in 1:x
            num = 2^8*img[i,j] + 2^7*img[i,j+1] + 2^6*img[i,j+2] +
                2^5*img[i+1,j] + 2^4*img[i+1,j+1] + 2^3*img[i+1,j+2] + 
                2^2*img[i+2,j] + 2^1*img[i+2,j+1] + 2^0*img[i+2,j+2]
            img2[i,j] = algorithm[num+1]
        end
        next_bg = img2[1,1]
        return (img2, next_bg)
    end

    bg = false
    for i in 1:50
        image, bg = enhance(image, algorithm, bg)
    end

    return sum(image)
end

input = readInput("in.txt")
# benchmark = @benchmark solve(input)
# display(benchmark)
result = solve(input)
display(result)
