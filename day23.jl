const Pos = Tuple{Int,Int}

function get_input(file)
    input = Pos[]
    for (y, line) in enumerate(readlines(file))
        for (x, ch) in enumerate(line)
            ch == '#' && push!(input, (y, x))
        end
    end
    return Set(input)
end

has_neighbours(elf, elves) =
    Bool[
        any([
            (elf[1] - 1, elf[2] - 1) in elves,
            (elf[1] - 1, elf[2]) in elves,
            (elf[1] - 1, elf[2] + 1) in elves,
        ]),
        any([
            (elf[1] + 1, elf[2] - 1) in elves,
            (elf[1] + 1, elf[2]) in elves,
            (elf[1] + 1, elf[2] + 1) in elves,
        ]),
        any([
            (elf[1] - 1, elf[2] - 1) in elves,
            (elf[1], elf[2] - 1) in elves,
            (elf[1] + 1, elf[2] - 1) in elves,
        ]),
        any([
            (elf[1] - 1, elf[2] + 1) in elves,
            (elf[1], elf[2] + 1) in elves,
            (elf[1] + 1, elf[2] + 1) in elves,
        ]),
    ]

function area(elves::Set{Pos})
    miny = minx = typemax(Int)
    maxy = maxx = typemin(Int)
    for elf in elves
        if miny > elf[1]
            miny = elf[1]
        elseif maxy < elf[1]
            maxy = elf[1]
        end
        if minx > elf[2]
            minx = elf[2]
        elseif maxx < elf[2]
            maxx = elf[2]
        end
    end
    return (maxy - miny + 1) * (maxx - minx + 1) - length(elves)
end

function day23(elves, max_rounds)
    offset = Pos[(-1, 0), (1, 0), (0, -1), (0, 1)]
    dir = 0
    for round in 1:max_rounds
        proposes = Dict{Pos,Pos}()
        conflicts = Dict{Pos,Int}()
        for elf in elves
            neighbours = has_neighbours(elf, elves)
            new_pos = elf
            any(neighbours) || continue
            for i in dir:dir+3
                idx = i % 4 + 1
                if !neighbours[idx]
                    new_pos = elf .+ offset[idx]
                    break
                end
            end

            if elf != new_pos
                proposes[elf] = new_pos
                conflicts[new_pos] = get(conflicts, new_pos, 0) + 1
            end
        end
        has_moves = false
        for (elf, pos) in proposes
            if get(conflicts, pos, 1) == 1
                delete!(elves, elf)
                push!(elves, pos)
                has_moves = true
            end
        end
        dir += 1
        has_moves || break
    end
    return area(elves), dir
end

println("Part 1: $(day23(get_input("day23.txt"), 10)[1])")           # 4109
println("Part 2: $(day23(get_input("day23.txt"), typemax(Int))[2])") # 1055