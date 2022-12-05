function day05a()
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
        nboxes = parse(Int, parts[2])
        source = parse(Int, parts[4])
        target = parse(Int, parts[6])
        for _ in 1:nboxes
            box = pop!(stacks[source])
            push!(stacks[target], box)
        end
    end
    top_boxes = [last(stack) for stack in stacks]
    @show join(top_boxes)
end

function day05b()
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
        nboxes = parse(Int, parts[2])
        source = parse(Int, parts[4])
        target = parse(Int, parts[6])
        tmp = Vector{Char}()
        for _ in 1:nboxes
            box = pop!(stacks[source])
            push!(tmp, box)
        end
        for _ in 1:nboxes
            box = pop!(tmp)
            push!(stacks[target], box)
        end
    end
    top_boxes = [last(stack) for stack in stacks]
    @show join(top_boxes)
end

day05a()
day05b()

