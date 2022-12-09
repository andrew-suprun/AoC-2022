function day09(lines, elves)
    offsets = Dict('R' => (1, 0), 'L' => (-1, 0), 'D' => (0, -1), 'U' => (0, 1))

    diffs = Dict(
        (-2, -2) => (-1, -1), (-2, -1) => (-1, -1), (-2, 0) => (-1, 0), (-2, 1) => (-1, 1), (-2, 2) => (-1, 1),
        (-1, -2) => (-1, -1), (-1, -1) => (0, 0), (-1, 0) => (0, 0), (-1, 1) => (0, 0), (-1, 2) => (-1, 1),
        (0, -2) => (0, -1), (0, -1) => (0, 0), (0, 0) => (0, 0), (0, 1) => (0, 0), (0, 2) => (0, 1),
        (1, -2) => (1, -1), (1, -1) => (0, 0), (1, 0) => (0, 0), (1, 1) => (0, 0), (1, 2) => (1, 1),
        (2, -2) => (1, -1), (2, -1) => (1, -1), (2, 0) => (1, 0), (2, 1) => (1, 1), (2, 2) => (1, 1),
    )

    knots = fill((0, 0), elves)
    visited = Set{Tuple{Int,Int}}()

    move = function (cmd)
        offset = offsets[cmd]
        knots[1] = (knots[1][1] + offset[1], knots[1][2] + offset[2])
        for i in 2:length(knots)
            prev = knots[i-1]
            next = knots[i]
            diff = diffs[(prev[1] - next[1], prev[2] - next[2])]
            knots[i] = (next[1] + diff[1], next[2] + diff[2])
        end

        push!(visited, knots[end])
    end


    cmds = map(lines) do line
        cmd, nstr = split(line)
        cmd[1], parse(Int, nstr)
    end

    for cmd in cmds
        for _ in 1:cmd[2]
            move(cmd[1])
        end
    end

    # Visualize the solution
    minx = miny = maxx = maxy = 0
    for v in visited
        if minx > v[1]
            minx = v[1]
        elseif maxx < v[1]
            maxx = v[1]
        end
        if miny > v[2]
            miny = v[2]
        elseif maxy < v[2]
            maxy = v[2]
        end
    end

    for y in maxy:-1:miny
        for x in minx:maxx
            if (x, y) in visited
                print('#')
            else
                print('.')
            end
        end
        println()
    end

    return length(visited)
end

println("Part 1:")
part1 = day09(readlines("day09.txt"), 2)  # 5883
println("\n\n\n\nPart 2:")
part2 = day09(readlines("day09.txt"), 10) # 2367
println("Part 1: $part1\nPart 2: $part2")