function day08(path)
    lines = readlines(path)
    @show lines
    grid = fill(0, length(lines), length(lines[1]))
    for i in 1:length(lines[1])
        for j in 1:length(lines)
            grid[i, j] = lines[i][j] - '0'
        end
    end
    x = length(lines)
    y = length(lines[1])
    visible = Set{Tuple{Int,Int}}()
    for i = 1:y
        tallest = -1
        println("----")
        for j in 1:x
            if grid[i, j] > tallest
                push!(visible, (i, j))
                tallest = grid[i, j]
                @show "+", i, j, grid[i, j]
            else
                @show "-", i, j, grid[i, j]
            end
        end
    end

    @show length(visible)

    for i = 1:y
        tallest = -1
        println("----")
        for j in x:-1:1
            if grid[i, j] > tallest
                push!(visible, (i, j))
                tallest = grid[i, j]
                @show "+", i, j, grid[i, j]
            else
                @show "-", i, j, grid[i, j]
            end
        end
    end

    @show length(visible)

    for j = 1:x
        tallest = -1
        println("----")
        for i in 1:y
            if grid[i, j] > tallest
                push!(visible, (i, j))
                tallest = grid[i, j]
                @show "+", i, j, grid[i, j]
            else
                @show "-", i, j, grid[i, j]
            end
        end
    end

    @show length(visible)

    for j = 1:x
        tallest = -1
        println("----")
        for i in y:-1:1
            if grid[i, j] > tallest
                push!(visible, (i, j))
                tallest = grid[i, j]
                @show "+", i, j, grid[i, j]
            else
                @show "-", i, j, grid[i, j]
            end
        end
    end

    @show length(visible) # part 1

    max = 0
    for i = 2:y-1
        for j in 2:x
            println("####", i, j)
            height = grid[i, j]
            @show "#", i, j, height
            down = 0
            for k in i+1:y
                down += 1
                @show "+down", k, j, grid[k, j], down
                if grid[k, j] >= height
                    break
                end
            end
            println("----")
            up = 0
            for k in i-1:-1:1
                up += 1
                @show "+up", k, j, grid[k, j], up
                if grid[k, j] >= height
                    break
                end
            end
            println("----")
            right = 0
            for k in j+1:x
                right += 1
                @show "+right", k, j, grid[i, k], right
                if grid[i, k] >= height
                    break
                end
            end
            println("----")
            left = 0
            for k in j-1:-1:1
                left += 1
                @show "+left", k, j, grid[i, k], left
                if grid[i, k] >= height
                    break
                end
                prod = up * down * right * left
                if max < prod
                    max = prod
                end
            end
        end
    end
    println(max)
end

day08("day08.txt")
