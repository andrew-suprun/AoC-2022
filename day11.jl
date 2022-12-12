mutable struct Monkey
    items::Vector{Int}
    operation::Function
    divisible::Int
    iftrue::Int
    iffalse::Int
    inspected::Int
    Monkey() = new([], () -> nothing, 0, 0, 0, 0)
end

function day11(lines, part, rounds)
    monkeys = Vector{Monkey}()
    monkey = Monkey()
    lines = strip.(lines)
    for line in lines
        terms = split(line, [',', ' '])
        if startswith(line, "Starting")
            monkey.items = map(x -> parse(Int, x), (terms[i] for i in 3:2:length(terms)))
        elseif startswith(line, "Operation")
            if terms[6] == "old"
                monkey.operation = x -> x * x
            elseif terms[5] == "+"
                op = parse(Int, terms[6])
                monkey.operation = (x) -> x + op
            elseif terms[5] == "*"
                op = parse(Int, terms[6])
                monkey.operation = (x) -> x * op
            end
        elseif startswith(line, "Test")
            monkey.divisible = parse(Int, terms[4])
        elseif startswith(line, "If true")
            monkey.iftrue = parse(Int, terms[6])
        elseif startswith(line, "If false")
            monkey.iffalse = parse(Int, terms[6])
            push!(monkeys, monkey)
            monkey = Monkey()
        end
    end

    common_multiple = lcm(monkeys .|> m -> m.divisible)

    for _ in 1:rounds
        for (i, monkey) in enumerate(monkeys)
            while !isempty(monkey.items)
                monkey.inspected += 1
                item = popfirst!(monkey.items)
                level = part == :part1 ? monkey.operation(item) ÷ 3 : monkey.operation(item) % common_multiple
                target = rem(level, monkey.divisible) == 0 ? monkey.iftrue : monkey.iffalse
                push!(monkeys[target+1].items, level)
            end
        end
    end
    inspected = monkeys .|> m -> m.inspected
    partialsort!(inspected, 1:2, rev=true)
    return inspected[1] * inspected[2]
end

using BenchmarkTools
println(@btime day11(readlines("day11.txt"), :part1, 20))
println(@btime day11(readlines("day11.txt"), :part2, 10_000))

#   114.500 μs (542 allocations: 44.09 KiB)
# 57838
#   60.659 ms (3597332 allocations: 54.93 MiB)
# 15050382231