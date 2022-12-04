day04(cond) = count(cond, readlines("day04.txt") .|> x -> split(x, ['-', ',']) .|> x -> parse(Int, x)) |> println

# part 1
day04(((a1, a2, b1, b2),) -> issubset(a1:a2, b1:b2) || issubset(b1:b2, a1:a2))

# part 2
day04(((a1, a2, b1, b2),) -> length(intersect(a1:a2, b1:b2)) > 0)