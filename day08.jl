function day08(lines)
    ncols = length(lines[1])
    nlines = length(lines)
    grid = [parse(Int, lines[line][col]) for line in 1:nlines, col in 1:ncols]

    # Part 1
    function visible(line, col)
        height = grid[line, col]
        return all(v < height for v in grid[1:line-1, col]) ||
               all(v < height for v in grid[line+1:nlines, col]) ||
               all(v < height for v in grid[line, 1:col-1]) ||
               all(v < height for v in grid[line, col+1:ncols])
    end
    part1 = sum(visible(line, col) for line in 1:nlines, col in 1:ncols)

    # Part 2
    function visible_trees(height, slice)
        count = 0
        for v in slice
            count += 1
            if height ≤ v
                break
            end
        end
        return count
    end

    all_directions = (height, line, col) ->
        visible_trees(height, grid[line, col-1:-1:1]) *
        visible_trees(height, grid[line, col+1:ncols]) *
        visible_trees(height, grid[line-1:-1:1, col]) *
        visible_trees(height, grid[line+1:nlines, col])

    part2 = maximum(all_directions(grid[line, col], line, col) for line in 1:nlines, col in 1:ncols)
    return part1, part2
end

part1, part2 = day08(readlines("day08.txt")) # 1820, 385112
println("Part 1: $part1\nPart 2: $part2")
