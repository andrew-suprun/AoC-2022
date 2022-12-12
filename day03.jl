function split_in_half(line)
    l = length(line) ÷ 2
    return [line[1:l], line[l+1:end]]
end

priority(letter) = letter ≥ 'a' && letter ≤ 'z' ? letter - 'a' + 1 : letter - 'A' + 27

print_priorities(letters) = (letters .|> x -> intersect(x...) |> first |> priority) |> sum |> println

# part 1
readlines("day03.txt") .|> split_in_half |> print_priorities

# part 2
readlines("day03.txt") |> x -> Base.Iterators.partition(x, 3) |> print_priorities