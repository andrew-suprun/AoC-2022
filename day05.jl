function day05(cranemover)
    lines = readlines("day05.txt")
    nline = 1
    while true
        if startswith(lines[nline], " 1 ")
            break
        end
        nline += 1
    end

    stacks = Vector{Vector{Char}}()

    for j in 2:4:length(lines[nline])
        stack = Vector{Char}()
        for k in nline-1:-1:1
            if lines[k][j] != ' '
                push!(stack, lines[k][j])
            end
        end
        push!(stacks, stack)
    end

    for line in lines[nline+2:end]
        parts = split(line, " ")
        ncrates = parse(Int, parts[2])
        source = parse(Int, parts[4])
        target = parse(Int, parts[6])
        cranemover(stacks, ncrates, source, target)
    end
    println(join(last(stack) for stack in stacks))
end

function cratemover_9000(stacks, ncrates, source, target)
    for _ in 1:ncrates
        push!(stacks[target], pop!(stacks[source]))
    end
end

function cratemover_9001(stacks, ncrates, source, target)
    tmp = Vector{Char}()
    for _ in 1:ncrates
        push!(tmp, pop!(stacks[source]))
    end
    for _ in 1:ncrates
        push!(stacks[target], pop!(tmp))
    end
end

day05(cratemover_9000)
day05(cratemover_9001)