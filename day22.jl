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

struct Position
    row::Int
    col::Int
end

const east = 0
const south = 1
const west = 2
const north = 3

Base.getindex(board::Board, pos::Position)::Char =
    if 0 ≤ pos.row < length(board.lines) && 0 ≤ pos.col < length(board.lines[pos.row+1])
        board.lines[pos.row+1][pos.col+1]
    else
        ' '
    end

score(pos::Position, dir::Int) = (pos.row + 1) * 1000 + (pos.col + 1) * 4 + dir

turn_right(dir::Int) = (dir + 1) % 4
turn_left(dir::Int) = (dir + 3) % 4

step(pos::Position, dir::Int)::Position =
    if dir == east
        Position(pos.row, pos.col + 1)
    elseif dir == south
        Position(pos.row + 1, pos.col)
    elseif dir == west
        Position(pos.row, pos.col - 1)
    else
        Position(pos.row - 1, pos.col)
    end

function peek(board::Board, pos::Position, dir::Int, ::Val{:part1})::Tuple{Char,Position,Int}
    next_pos = step(pos, dir)

    if board[next_pos] == ' '
        if dir == east
            next_pos = Position(next_pos.row, 0)
        elseif dir == west
            next_pos = Position(next_pos.row, 4board.side)
        elseif dir == south
            next_pos = Position(0, next_pos.col)
        elseif dir == north
            next_pos = Position(4board.side, next_pos.col)
        end
        while board[next_pos] == ' '
            next_pos = step(next_pos, dir)
        end
    end
    return board[next_pos], next_pos, dir
end

function skip_empty_space(board::Board, pos::Position, dir::Int)::Position
    while board[pos] == ' '
        pos = step(pos, dir)
    end
    return pos
end

function peek(board::Board, pos::Position, dir::Int, ::Val{:part2})::Tuple{Char,Cursor}
    next_pos = cursor.pos .+ cursor.dir
    if board[next_pos] != ' '
        return board[next_pos], Cursor(next_pos, cursor.dir)
    end

    base = (next_pos .+ board.side) .÷ board.side .* board.side .- board.side
    inner_pos = next_pos .- base
    inner_poss = [
        inner_pos,
        (inner_pos.col, board.side - inner_pos.row - 1),
        (board.side - inner_pos.col - 1, inner_pos.row),
        (board.side - inner_pos.row - 1, board.side - inner_pos.col - 1),
    ]

    right_shift = turn_right(cursor.dir) .* board.side
    forward_shift = cursor.dir .* board.side

    for switch in switches
        new_pos = base .+ switch.right_turn .* right_shift .+ switch.forward .* forward_shift .+ inner_poss[switch.pos]
        if board[new_pos] != ' '
            println("switch=$switch")
            println("    current   $next_pos, $(cursor.dir)")
            println("    base      $base")
            println("    inner     $inner_pos")
            println("    rotated   $(inner_poss[switch.pos])")
            println("    rightward $(switch.right_turn .* right_shift)")
            println("    forward   $(switch.forward .* forward_shift)")
            println("    next      $new_pos $(switch.dir(cursor.dir)): '$(board[new_pos])'")

            return board[new_pos], Cursor(new_pos, switch.dir(cursor.dir))
        end
    end

    throw("Implement me!")
end

function move(board::Board, pos::Position, dir::Int, steps::Int, part)::Tuple{Position,Int}
    for _ in 1:steps
        char, next_pos, next_dir = peek(board, pos, dir, part)
        if char == '#'
            return pos, dir
        end
        pos, dir = next_pos, next_dir
    end
    return pos, dir
end

function day22(board::Board, pos::Position, dir::Int, cmds::Commands, part)
    for cmd in cmds
        if cmd == 'R'
            dir = turn_right(dir)
        elseif cmd == 'L'
            dir = turn_left(dir)
        else
            pos, dir = move(board, pos, dir, cmd, part)
        end
    end
    return score(pos, dir)
end

function get_input(lines)
    cmds = Commands(lines[end])
    lines = lines[1:end-2]
    board = Board(lines)
    pos = skip_empty_space(board, Position(0, 0), east)
    return board, pos, east, cmds
end

board, pos, dir, cmds = get_input(readlines("day22.txt"))
println("Part 1: $(day22(board, pos, dir, cmds, Val(:part1)))") # 73346
# println("Part 2: $(day22(board, pos, dir, cmds, Val(:part2)))") # < 147330, > 59349


# 10 R 5 L 5 R 10 L 4 R 5 L 5
