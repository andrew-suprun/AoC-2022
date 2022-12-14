should_fall_though(::Val{:part1}, y, ymax) = y ≥ ymax
should_fall_though(::Val{:part2}, y, ymax) = false

function day14(part, lines)
    grid = Set(Tuple{Int,Int}[])
    xmin = ymin = typemax(Int)
    xmax = ymax = typemin(Int)
    for line in lines
        line_parts = parse.(Int, filter(x -> x != "->", split(line, [',', ' '])))
        for t in 1:2:length(line_parts)-3
            x1, y1, x2, y2 = line_parts[t:t+3]
            x1, x2 = min(x1, x2), max(x1, x2)
            y1, y2 = min(y1, y2), max(y1, y2)
            xmin = min(xmin, x1)
            xmax = max(xmax, x2)
            ymin = min(ymin, y1)
            ymax = max(ymax, y2)
            for x in x1:x2, y in y1:y2
                push!(grid, (x, y))
            end
        end
    end

    units = 0
    while true
        x, y = 500, 0
        fall_though = false
        while true
            if should_fall_though(part, y, ymax)
                fall_though = true
                break
            end

            found_empty = false
            if y ≤ ymax
                for newx in [x, x - 1, x + 1]
                    if !((newx, y + 1) in grid)
                        x = newx
                        y += 1
                        found_empty = true
                        break
                    end
                end
            end

            if !found_empty
                push!(grid, (x, y))
                units += 1
                break
            end
        end
        if fall_though || (x, y) == (500, 0)
            break
        end
    end
    return units
end

lines = readlines("day14.txt")
println(day14(Val(:part1), lines)) #   858
println(day14(Val(:part2), lines)) # 26845