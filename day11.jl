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
        if startswith(line, "Starting items: ")
            monkey.items = map(x -> parse(Int, x), [terms[i] for i in 3:2:length(terms)])
        elseif startswith(line, "Operation: new = ")
            if terms[6] == "old"
                monkey.operation = x -> x * x
            elseif terms[5] == "+"
                op = parse(Int, terms[6])
                monkey.operation = (x) -> x + op
            elseif terms[5] == "*"
                op = parse(Int, terms[6])
                monkey.operation = (x) -> x * op
            end
        elseif startswith(line, "Test: divisible by ")
            monkey.divisible = parse(Int, terms[4])
        elseif startswith(line, "If true: throw to monkey ")
            monkey.iftrue = parse(Int, terms[6])
        elseif startswith(line, "If false: throw to monkey ")
            monkey.iffalse = parse(Int, terms[6])
            push!(monkeys, monkey)
            monkey = Monkey()
        end
    end

    common_divisor = prod(monkeys .|> m -> m.divisible)

    for _ in 1:rounds
        for (i, monkey) in enumerate(monkeys)
            while !isempty(monkey.items)
                monkey.inspected += 1
                item = popfirst!(monkey.items)
                if part === :part1
                    level = div(monkey.operation(item), 3)
                else
                    level = monkey.operation(item)
                    level = rem(level, common_divisor)
                end
                if rem(level, monkey.divisible) == 0
                    push!(monkeys[monkey.iftrue+1].items, level)
                else
                    push!(monkeys[monkey.iffalse+1].items, level)
                end
            end
        end
    end
    inspected = monkeys .|> m -> m.inspected
    partialsort!(inspected, 1:2, rev=true)
    return inspected[1] * inspected[2]
end

println(day11(readlines("day11.txt"), :part1, 20))
println(day11(readlines("day11.txt"), :part2, 10_000))