mutable struct Cell
    value::Int
    next::Cell
    prev::Cell
    Cell(v::Int) = new(v)
end

function move(cell::Cell, n::Int)
    n == 0 && return

    cell.prev.next = cell.next
    cell.next.prev = cell.prev

    cursor = cell
    for _ in 1:n
        cursor = cursor.next
    end

    cell.next = cursor.next
    cell.prev = cursor
    cursor.next.prev = cell
    cursor.next = cell
end

function day20(numbers, part)
    n = length(numbers)
    cells = [Cell(v) for v in numbers]
    for i in 1:length(cells)-1
        cells[i].next = cells[i+1]
        cells[i+1].prev = cells[i]
    end
    cells[length(cells)].next = cells[1]
    cells[1].prev = cells[length(cells)]

    cycles = 1
    if part == :part2
        cycles = 10
        for i in eachindex(cells)
            cells[i].value *= 811589153
        end
    end

    for _ in 1:cycles
        for i in 1:n
            mod = cells[i].value % (n - 1)
            move(cells[i], mod > 0 ? mod : mod + n - 1)
        end
    end
    cursor = cells[1]
    for i in 1:n
        if cursor.value == 0
            break
        end
        cursor = cursor.next
    end
    total = 0
    for _ in 1:3
        for _ in 1:1000
            cursor = cursor.next
        end
        total += cursor.value
    end
    return total
end

numbers = parse.(Int, readlines("day20.txt"))
println("Part 1: $(day20(numbers, :part1))") #          4267
println("Part 2: $(day20(numbers, :part2))") # 6871725358451
