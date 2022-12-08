function day08(path)
    lines = readlines(path)
    ncols = length(lines[1])
    nlines = length(lines)
    grid = [parse(Int, lines[line][col]) for line in 1:nlines, col in 1:ncols]

    # Part 1
    visible(line, col) = all(v < grid[line, col] for v in grid[1:line-1, col]) ||
                         all(v < grid[line, col] for v in grid[line+1:nlines, col]) ||
                         all(v < grid[line, col] for v in grid[line, 1:col-1]) ||
                         all(v < grid[line, col] for v in grid[line, col+1:ncols])
    part1 = sum(visible(line, col) for line in 1:nlines, col in 1:ncols)
    println("Part 1: $(sum(part1))")

    # Part 2
    visible_trees = function (height, slice)
        count = 0
        for v in slice
            count += 1
            if height <= v
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
    println("Part 2: $part2")
end

day08("day08.txt")