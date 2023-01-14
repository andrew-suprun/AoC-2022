const Pos = Tuple{Int,Int}
const Dir = Char

struct Valley
    maxy::Int
    maxx::Int
    data::Dict{Pos,Dir}
    progress::Set{Pos}
end

function get_input(lines)
    input = Dict{Pos,Dir}()
    for (y, line) in enumerate(lines[2:end-1])
        for (x, char) in enumerate(line[2:end-1])
            if char != '.'
                input[(y, x)] = char
            end
        end
    end
    return Valley((length(lines) - 2), (length(lines[1]) - 2), input, Set{Pos}())
end

function set_progress(valley, steps)
    empty!(valley.progress)
    for (pos, dir) in valley.data
        orig = pos
        if dir == '>'
            pos = ((pos[1], (pos[2] + steps - 1) % valley.maxx + 1))
        elseif dir == '<'
            pos = ((pos[1], (pos[2] + valley.maxx - (steps % valley.maxx) - 1) % valley.maxx + 1))
        elseif dir == 'v'
            pos = (((pos[1] + steps - 1) % valley.maxy + 1), pos[2])
        elseif dir == '^'
            pos = (((pos[1] + valley.maxy - (steps % valley.maxy) - 1) % valley.maxy + 1), pos[2])
        end
        push!(valley.progress, pos)
    end
end

function is_available(valley, pos)
    if pos == (0, 1) || pos == (valley.maxy + 1, valley.maxx)
        return true
    end
    if pos[1] < 1 || pos[1] > valley.maxy || pos[2] < 1 || pos[2] > valley.maxx
        return false
    end
    return !(pos in valley.progress)
end

function day24(valley, goals...)
    set = Set{Pos}([goals[1]])
    next_goal = 2

    for step in 1:typemax(Int)
        set_progress(valley, step)
        next_set = Set{Pos}()
        for pos in set
            poses = [pos, (pos[1], pos[2] + 1), (pos[1], pos[2] - 1), (pos[1] + 1, pos[2]), (pos[1] - 1, pos[2])]
            for p in poses
                if is_available(valley, p)
                    push!(next_set, p)
                end
            end
        end
        if goals[next_goal] in next_set
            if next_goal == length(goals)
                return step
            else
                next_set = Set{Pos}([goals[next_goal]])
                next_goal += 1
            end
        end
        set = next_set
    end
end

valley = get_input(readlines("day24.txt"))
println("Part 1: $(day24(valley, (0, 1), (valley.maxy + 1, valley.maxx)))")                                         # 255
println("Part 2: $(day24(valley, (0, 1), (valley.maxy + 1, valley.maxx), (0, 1), (valley.maxy + 1, valley.maxx)))") # 809
