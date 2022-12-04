day04(cond) = count(cond, readlines("day04.txt") .|> x -> split(x, ['-', ',']) .|> x -> parse(Int, x)) |> println

# part 1
day04(((a1, a2, b1, b2),) -> a1 <= b1 <= b2 <= a2 || b1 <= a1 <= a2 <= b2)

# part 2
day04(((a1, a2, b1, b2),) -> a1 <= b1 <= a2 || a1 <= b2 <= a2 || b1 <= a1 <= b2)