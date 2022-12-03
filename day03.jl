function split_in_half(line)
    l = div(length(line), 2)
    return line[1:l], line[l+1:end]
end

priority(letter) = letter >= 'a' && letter <= 'z' ? letter - 'a' + 1 : letter - 'A' + 27

print_priorities(letters) = println(sum(priority(letter) for letter in letters))

function day03a()
    pairs = (split_in_half(line) for line in readlines("day03.txt"))
    print_priorities(pop!(intersect(Set(pair[1]), Set(pair[2]))) for pair in pairs)
end

function day03b()
    groups = Base.Iterators.partition((line for line in readlines("day03.txt")), 3)
    print_priorities(pop!(intersect(Set(group[1]), Set(group[2]), Set(group[3]))) for group in groups)
end

day03a()
day03b()

