function day07(lines)
    stats = Dict{Vector{String},Int}()
    cwd = Vector{String}()
    for line in lines
        cmd_line = split(line, ' ')
        if cmd_line[1] == "\$"
            if cmd_line[2] == "cd"
                if cmd_line[3] == ".."
                    cwd = copy(cwd[1:end-1])
                elseif cmd_line[3] != "/"
                    cwd = push!(copy(cwd), cmd_line[3])
                end
            end
        elseif !startswith(line, "dir")
            size = parse(Int, cmd_line[1])
            stats[cwd] = get(stats, cwd, 0) + size
            wd = cwd
            while length(wd) > 0
                wd = wd[1:end-1]
                stats[wd] = get(stats, wd, 0) + size
            end
        end
    end

    sizes = stats |> values |> collect

    part1 = sum(filter(x -> x < 100000, sizes))

    min_size = stats[[]] - 40_000_000
    part2 = minimum(filter(x -> x > min_size, sizes))
    return part1, part2
end

part1, part2 = day07(readlines("day07.txt"))
println("Part 1: $part1\nPart 2: $part2")