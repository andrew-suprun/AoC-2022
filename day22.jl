struct Commands
    line::String
end

struct Board
    lines::Vector{String}
    side::Int
    function Board(lines::Vector{String})
        size = length(lines), maximum(length(line) for line in lines)
        new(lines, minimum(size) ÷ 3)
    end
end

struct Direction
    to::Int
end

struct Position
    row::Int
    col::Int
end

struct Link
    pos::Position
    dir::Direction
end

struct Links
    links::Vector{Union{Link,Nothing}}
end

const Cube = Dict{Position,Links}

const east = Direction(1)
const south = Direction(2)
const west = Direction(3)
const north = Direction(4)
const directions = [east, south, west, north]

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

Base.:(+)(pos1::Position, pos2::Position) = Position(pos1.row + pos2.row, pos1.col + pos2.col)
Base.:(-)(pos1::Position, pos2::Position) = Position(pos1.row - pos2.row, pos1.col - pos2.col)
Base.:(+)(pos::Position, i::Int) = Position(pos.row + i, pos.col + i)
Base.:(-)(pos::Position, i::Int) = Position(pos.row - i, pos.col - i)
Base.:(*)(pos::Position, i::Int) = Position(pos.row * i, pos.col * i)
Base.:(÷)(pos::Position, i::Int) = Position(pos.row ÷ i, pos.col ÷ i)

turn_right(dir::Direction) = Direction((dir.to + 4) % 4 + 1)
turn_left(dir::Direction) = Direction((dir.to + 2) % 4 + 1)
Base.:(-)(dir1::Direction, dir2::Direction) = (dir1.to - dir2.to + 4) % 4

function turn(dir::Direction, diff::Int)
    for _ in 1:diff
        dir = turn_right(dir)
    end
    return dir
end

Base.getindex(board::Board, pos::Position)::Char =
    if 0 ≤ pos.row < length(board.lines) && 0 ≤ pos.col < length(board.lines[pos.row+1])
        board.lines[pos.row+1][pos.col+1]
    else
        ' '
    end

isface(board::Board, pos::Position) = board[pos] != ' '

function init_cube(board::Board)
    cube = Dict{Position,Links}()
    for row in 0:board.side:3board.side, col in 0:board.side:3board.side
        pos = Position(row, col)
        if isface(board, pos)
            cube[pos] = Links([nothing, nothing, nothing, nothing])
        end
    end
    return cube
end

function cube_part1(board::Board)
    cube = init_cube(board)
    for (pos_from, links_from) in cube
        for dir in directions
            pos_to = step(pos_from, dir, board.side)
            if isface(board, pos_to)
                links_from.links[dir.to] = Link(pos_to, dir)
            else
                for i in -3:0
                    pos_to = step(pos_from, dir, i * board.side)
                    if isface(board, pos_to)
                        links_from.links[dir.to] = Link(pos_to, dir)
                        break
                    end
                end
            end
        end
    end
    return cube
end

function cube_part2(board::Board)
    cube = init_cube(board)
    for (pos_from, links_from) in cube
        for dir in directions
            pos_to = step(pos_from, dir, board.side)
            if isface(board, pos_to)
                links_from.links[dir.to] = Link(pos_to, dir)
            end
        end
    end
    while true
        has_changes = false
        for (pos, links) in cube
            for dir1 in directions
                dir2 = turn_right(dir1)
                link1 = links.links[dir1.to]
                link2 = links.links[dir2.to]
                if link1 !== nothing && link2 !== nothing
                    pos1_links = cube[link1.pos]
                    pos2_links = cube[link2.pos]
                    if pos1_links.links[turn_right(link1.dir).to] === nothing
                        has_changes = true
                        pos1_links.links[turn_right(link1.dir).to] = Link(link2.pos, turn(turn_right(dir2), link2.dir - dir2))
                        pos2_links.links[turn_left(link2.dir).to] = Link(link1.pos, turn(turn_left(dir1), link1.dir - dir1))
                    end
                end
            end
        end
        if !has_changes
            break
        end
    end
    return cube
end

score(pos::Position, dir::Direction) = (pos.row + 1) * 1000 + (pos.col + 1) * 4 + dir.to - 1

step(pos::Position, dir::Direction, size::Int=1)::Position =
    if dir == east
        Position(pos.row, pos.col + size)
    elseif dir == south
        Position(pos.row + size, pos.col)
    elseif dir == west
        Position(pos.row, pos.col - size)
    elseif dir == north
        Position(pos.row - size, pos.col)
    else
        throw("BAD Direction")
    end

function peek(board::Board, pos::Position, dir::Direction, cube::Cube)::Tuple{Char,Position,Direction}
    next_pos = step(pos, dir)
    if board[next_pos] != ' '
        return board[next_pos], next_pos, dir
    end

    base = (pos + board.side) ÷ board.side * board.side - board.side
    link = cube[base].links[dir.to]

    inner_pos = next_pos - step(base, dir, board.side)
    for _ in 1:link.dir-dir
        inner_pos = Position(inner_pos.col, board.side - inner_pos.row - 1)
    end
    next_pos = inner_pos + link.pos
    return board[next_pos], next_pos, link.dir
end

function move(board::Board, pos::Position, dir::Direction, steps::Int, cube::Cube)::Tuple{Position,Direction}
    for _ in 1:steps
        char, next_pos, next_dir = peek(board, pos, dir, cube)
        if char == '#'
            return pos, dir
        end
        pos, dir = next_pos, next_dir
    end
    return pos, dir
end

function day22(board::Board, pos::Position, dir::Direction, cmds::Commands, cube::Cube)
    for cmd in cmds
        if cmd == 'R'
            dir = turn_right(dir)
        elseif cmd == 'L'
            dir = turn_left(dir)
        else
            pos, dir = move(board, pos, dir, cmd, cube)
        end
    end
    return score(pos, dir)
end

function get_input(lines)
    cmds = Commands(lines[end])
    lines = lines[1:end-2]
    board = Board(lines)
    pos = Position(0, 0)
    while board[pos] == ' '
        pos = step(pos, east)
    end
    return board, pos, east, cmds
end

board, pos, dir, cmds = get_input(readlines("day22.txt"))
println("Part 1:  $(day22(board, pos, dir, cmds, cube_part1(board)))") #  73346
println("Part 2: $(day22(board, pos, dir, cmds, cube_part2(board)))")  # 106392
