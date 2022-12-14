function start_positins end

function day12(part, lines)
    nlines, nrows = length(lines), length(lines[1])
    heightmap = Matrix{Int}(undef, nlines, nrows)
    start = (0, 0)
    target = (0, 0)
    for l in eachindex(lines), r in eachindex(lines[l])
        if lines[l][r] == 'S'
            heightmap[l, r] = 0
            start = (l, r)
        elseif lines[l][r] == 'E'
            heightmap[l, r] = 'z' - 'a'
            target = (l, r)
        else
            heightmap[l, r] = lines[l][r] - 'a'
        end
    end

    visited, current_level = start_positins(part, lines)

    push!(visited, start)
    push!(current_level, start)

    steps = 0
    while true
        next_level = Vector{Tuple{Int,Int}}()
        for (l, r) in current_level
            current_height = heightmap[l, r]

            if r < nrows && heightmap[l, r+1] - 1 <= current_height && !((l, r + 1) in visited)
                push!(visited, (l, r + 1))
                push!(next_level, (l, r + 1))
            end
            if r > 1 && heightmap[l, r-1] - 1 <= current_height && !((l, r - 1) in visited)
                push!(visited, (l, r - 1))
                push!(next_level, (l, r - 1))
            end
            if l < nlines && heightmap[l+1, r] - 1 <= current_height && !((l + 1, r) in visited)
                push!(visited, (l + 1, r))
                push!(next_level, (l + 1, r))
            end
            if l > 1 && heightmap[l-1, r] - 1 <= current_height && !((l - 1, r) in visited)
                push!(visited, (l - 1, r))
                push!(next_level, (l - 1, r))
            end
        end

        current_level = next_level
        steps += 1
        target in visited && break
    end
    return steps
end

start_positins(::Val{:part1}, lines) = Set(Tuple{Int,Int}[]), Tuple{Int,Int}[]

function start_positins(::Val{:part2}, lines)
    visited = Set(Tuple{Int,Int}[])
    current_level = Tuple{Int,Int}[]
    for l in eachindex(lines), r in eachindex(lines[l])
        if lines[l][r] == 'a'
            push!(visited, (l, r))
            push!(current_level, (l, r))
        end
    end
    return visited, current_level
end

lines = readlines("day12.txt")
println(day12(Val(:part1), lines)) # 472
println(day12(Val(:part2), lines)) # 465
