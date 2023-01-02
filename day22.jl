mutable struct Commands
    line::String
end

function Base.iterate(iter::Commands, state=1)
    state > length(iter.line) && return nothing
    ch = iter.line[state]
    if ch == 'R'
        return 'R', state + 1
    elseif ch == 'L'
        return 'L', state + 1
    end
    result = 0
    while state ≤ length(iter.line)
        result = 10result + iter.line[state] - '0'
        state += 1
        if state > length(iter.line) || iter.line[state] > '9'
            return result, state
        end
    end
end

struct Board
    lines::Vector{String}
    side::Int
    function Board(lines::Vector{String})
        size = length(lines), maximum(length(line) for line in lines)
        new(lines, minimum(size) ÷ 3)
    end
end

Base.getindex(board::Board, position::Tuple{Int,Int})::Char =
    if 0 ≤ position[1] < length(board.lines) && 0 ≤ position[2] < length(board.lines[position[1]+1])
        board.lines[position[1]+1][position[2]+1]
    else
        ' '
    end

struct Cursor
    position::Tuple{Int,Int}
    direction::Tuple{Int,Int}
end

score(cursor::Cursor) = (cursor.position[1] + 1) * 1000 + (cursor.position[2] + 1) * 4 + direction(cursor)

turn_right(direction::Tuple{Int,Int}) =
    if direction == (0, 1)
        (1, 0)
    elseif direction == (0, -1)
        (-1, 0)
    elseif direction == (1, 0)
        (0, -1)
    else
        (0, 1)
    end

turn_left(direction::Tuple{Int,Int}) =
    if direction == (0, 1)
        (-1, 0)
    elseif direction == (0, -1)
        (1, 0)
    elseif direction == (1, 0)
        (0, 1)
    else
        (0, -1)
    end

function peek(board::Board, cursor::Cursor, ::Val{:part1})::Tuple{Char,Cursor}
    next_position = cursor.position .+ cursor.direction

    if board[next_position] == ' '
        if cursor.direction == (0, 1)
            next_position = (next_position[1], 0)
        elseif cursor.direction == (0, -1)
            next_position = (next_position[1], 4board.side)
        elseif cursor.direction == (1, 0)
            next_position = (0, next_position[2])
        elseif cursor.direction == (-1, 0)
            next_position = (4board.side, next_position[2])
        end
        while board[next_position] == ' '
            next_position = next_position .+ cursor.direction
        end
    end
    return board[next_position], Cursor(next_position, cursor.direction)
end

function skip_empty_space(board::Board, cursor::Cursor)
    while board[cursor.position] == ' '
        cursor = Cursor(cursor.position .+ cursor.direction, cursor.direction)
    end
    return cursor
end

function peek(board::Board, cursor::Cursor, ::Val{:part2})::Tuple{Char,Cursor}
    next_position = cursor.position .+ cursor.direction
    @show next_position, cursor.direction
    if board[next_position] != ' '
        return board[next_position], Cursor(next_position, cursor.direction)
    end

    @show inner_position = next_position .% board.side
    @show right_position = inner_position[2], board.side - inner_position[1] - 1
    @show left_position = board.side - inner_position[2] - 1, inner_position[1]
    @show reverse_position = board.side - inner_position[1] - 1, board.side - inner_position[2] - 1
    base = next_position .÷ board.side .* board.side

    switch_right = base .+ right_position .+ turn_right(cursor.direction) .* board.side
    @show switch_right, board[switch_right]
    if board[switch_right] != ' '
        return board[switch_right], Cursor(switch_right, turn_right(cursor.direction))
    end

    switch_right2 = base .+ right_position .- turn_right(cursor.direction) .* 2board.side .- cursor.direction .* 3board.side
    @show switch_right2, board[switch_right2]
    if board[switch_right2] != ' '
        return board[switch_right2], Cursor(switch_right2, turn_right(cursor.direction))
    end

    switch_left = turn_left(cursor.direction) .* board.side .+ base .+ left_position
    @show switch_left, board[switch_left]
    if board[switch_left] != ' '
        return board[switch_left], Cursor(switch_left, turn_left(cursor.direction))
    end

    switch_left2 = base .+ left_position .- turn_left(cursor.direction) .* 2board.side .- cursor.direction .* 3board.side
    @show switch_left2, board[switch_left2]
    if board[switch_left2] != ' '
        return board[switch_left2], Cursor(switch_left2, turn_left(cursor.direction))
    end

    switch_left3 = base .+ left_position .- turn_left(cursor.direction) .* 3board.side .- cursor.direction .* board.side
    @show switch_left3, board[switch_left3]
    if board[switch_left3] != ' '
        return board[switch_left3], Cursor(switch_left3, turn_left(cursor.direction))
    end

    reverse_left = base .+ reverse_position .- turn_left(cursor.direction) .* 2board.side .- cursor.direction .* 2board.side
    @show reverse_left, board[reverse_left]
    if board[reverse_left] != ' '
        return board[reverse_left], Cursor(reverse_left, (0, 0) .- cursor.direction)
    end

    reverse_left2 = base .+ reverse_position .+ turn_left(cursor.direction) .* 3board.side
    @show reverse_left2, board[reverse_left2]
    if board[reverse_left2] != ' '
        return board[reverse_left2], Cursor(reverse_left2, (0, 0) .- cursor.direction)
    end

    reverse_left3 = base .+ reverse_position .+ turn_left(cursor.direction) .* 2board.side
    @show reverse_left3, board[reverse_left3]
    if board[reverse_left3] != ' '
        return board[reverse_left3], Cursor(reverse_left3, (0, 0) .- cursor.direction)
    end

    straight_left = base .+ inner_position .- turn_left(cursor.direction) .* 2board.side .- cursor.direction .* 4board.side
    @show straight_left, board[straight_left]
    if board[straight_left] != ' '
        return board[straight_left], Cursor(straight_left, cursor.direction)
    end

    reverse_right = base .+ reverse_position .- turn_right(cursor.direction) .* 2board.side .- cursor.direction .* 2board.side
    @show reverse_right, board[reverse_right]
    if board[reverse_right] != ' '
        return board[reverse_right], Cursor(reverse_right, (0, 0) .- cursor.direction)
    end

    reverse_right2 = base .+ reverse_position .+ turn_left(cursor.direction) .* 3board.side
    @show reverse_right2, board[reverse_right2]
    if board[reverse_right2] != ' '
        return board[reverse_right2], Cursor(reverse_right2, (0, 0) .- cursor.direction)
    end

    reverse_right3 = base .+ reverse_position .+ turn_right(cursor.direction) .* 2board.side
    @show reverse_right3, board[reverse_right3]
    if board[reverse_right3] != ' '
        return board[reverse_right3], Cursor(reverse_right3, (0, 0) .- cursor.direction)
    end

    straight_right = base .+ inner_position .- turn_right(cursor.direction) .* 2board.side .- cursor.direction .* 4board.side
    @show straight_right, board[straight_right]
    if board[straight_right] != ' '
        return board[straight_right], Cursor(straight_right, (0, 0) .- cursor.direction)
    end


    throw("Implement me!")
end

function move(board::Board, cursor::Cursor, steps::Int, part)::Cursor
    for _ in 1:steps
        char, next_cursor = peek(board, cursor, part)
        if char == '#'
            return cursor
        end
        cursor = next_cursor
    end
    return cursor
end


direction(cursor::Cursor) =
    if cursor.direction == (0, 1)
        0
    elseif cursor.direction == (1, 0)
        1
    elseif cursor.direction == (0, -1)
        2
    else
        3
    end

function day22(board::Board, cursor::Cursor, cmds::Commands, part)
    @show cursor
    for cmd in cmds
        @show cmd
        if cmd == 'R'
            cursor = Cursor(cursor.position, turn_right(cursor.direction))
        elseif cmd == 'L'
            cursor = Cursor(cursor.position, turn_left(cursor.direction))
        else
            cursor = move(board, cursor, cmd, part)
        end
        @show cursor
    end
    return score(cursor)
end

function get_input(lines)
    cmds = Commands(lines[end])
    lines = lines[1:end-2]
    board = Board(lines)
    cursor = skip_empty_space(board, Cursor((0, 0), (0, 1)))
    return board, cursor, cmds
end

board, cursor, cmds = get_input(readlines("day22.txt"))
# println("Part 1: $(day22(board, cursor, cmds, Val(:part1)))") # 73346
println("Part 2: $(day22(board, cursor, cmds, Val(:part2)))") # < 153072


# 10 R 5 L 5 R 10 L 4 R 5 L 5
