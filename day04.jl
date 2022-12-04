function day04a()
    count = 0
    for line in readlines("day04.txt")
        (a1, a2, b1, b2) = parse.(Int, split(line, ['-', ',']))
        if a1 <= b1 <= b2 <= a2 || b1 <= a1 <= a2 <= b2
            count += 1
        end
    end
    println(count)
end

function day04b()
    count = 0
    for line in readlines("day04.txt")
        (a1, a2, b1, b2) = parse.(Int, split(line, ['-', ',']))
        if a1 <= b1 <= a2 || a1 <= b2 <= a2 || b1 <= a1 <= b2 || b1 <= a2 <= b2
            count += 1
        end
    end
    println(count)
end

day04a()
day04b()