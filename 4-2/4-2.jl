using DelimitedFiles
using BenchmarkTools

function readInput(path)
    open(path, "r") do f
        data = readdlm(f, '\n', String)
        
        numbers = parse.(Int, split(data[1], ','))

        board_size = 5
        n_boards = (length(data) - 1)÷board_size
        boards = Array{Int32}(undef, n_boards, board_size, board_size)
        for i in 1:n_boards, j in 1:board_size
            row_idx = board_size * (i-1) + j + 1
            row = parse.(Int32, split(data[row_idx]))
            boards[i, j, :] .= row
        end
        return numbers, boards
    end
end

function solve(input)
    numbers, boards = deepcopy(input)

    n_boards, board_size, _ = size(boards)

    function is_winner(board)
        for i in 1:board_size
            if sum(@view board[i,:]) == -board_size || sum(@view  board[:,i]) == -board_size
                return true
            end
        end
        return false
    end

    active_boards = Set(1:n_boards)
    last_score = 0
    for n in numbers
        replace!(boards, n=>-1)
        for i in active_boards
            board = @view boards[i,:,:]
            if is_winner(board)
                last_score = n * sum(board[board .!= -1])
                delete!(active_boards, i)
            end
        end
    end
    return last_score
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)