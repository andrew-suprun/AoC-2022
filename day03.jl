read_lines() = [line for line in readlines("day03.txt")]

function split_in_half(line)
    l = div(length(line), 2)
    return SubString(line, 1, l), SubString(line, l + 1)
end

function priority(letter)
    if letter >= 'a' && letter <= 'z'
        return letter - 'a' + 1
    else
        return letter - 'A' + 27
    end
end

function split_groups(lines)
    i = 0
    groups = Vector{Vector{String}}()
    for line in lines
        if mod(i, 3) == 0
            push!(groups, [])
        end
        push!(groups[end], line)
        i += 1
    end
    return groups
end

function day03a()
    lines = read_lines()
    pairs = [split_in_half(line) for line in lines]
    common_letters = [pop!(intersect(Set(pair[1]), Set(pair[2]))) for pair in pairs]
    priorities = [priority(letter) for letter in common_letters]
    println(sum(priorities))
end

function day03b()
    lines = read_lines()
    groups = split_groups(lines)
    common_letters = [pop!(intersect(Set(group[1]), Set(group[2]), Set(group[3]))) for group in groups]
    priorities = [priority(letter) for letter in common_letters]
    println(sum(priorities))
end

day03a()
day03b()

