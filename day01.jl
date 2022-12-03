function split_by_elf(input)
    result = [[]]
    for line in input
        if line == ""
            push!(result, [])
        else
            push!(result[end], line)
        end
    end
    return result
end

elf_calories(calories) = sum(parse(Int, line) for line in calories)

read_data() = readlines("day01.txt") |> split_by_elf .|> elf_calories

# part 1
read_data() |> maximum |> println

# part 2
read_data() |> x -> partialsort(x, 1:3, rev=true) |> sum |> println