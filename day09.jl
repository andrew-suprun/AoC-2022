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

    function move(cmd)
        knots[1] = (knots[1][1] + offsets[cmd][1], knots[1][2] + offsets[cmd][2])
        for i in 2:length(knots)
            prev, next = knots[i-1], knots[i]
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

    return length(visited)
end

part1 = day09(readlines("day09.txt"), 2)  # 5883
part2 = day09(readlines("day09.txt"), 10) # 2367
println("Part 1: $part1\nPart 2: $part2")
