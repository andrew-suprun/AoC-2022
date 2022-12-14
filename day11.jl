mutable struct Monkey
    items::Vector{Int}
    operation::Function
    divisible::Int
    iftrue::Int
    iffalse::Int
    inspected::Int
    Monkey() = new([], () -> nothing, 0, 0, 0, 0)
end

update_level(::Val{:part1}, level, common_multiple) = level ÷ 3
update_level(::Val{:part2}, level, common_multiple) = level % common_multiple

function day11(part, lines, rounds)
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

    for _ in 1:rounds, monkey in monkeys
        while !isempty(monkey.items)
            monkey.inspected += 1
            item = popfirst!(monkey.items)
            level = update_level(part, monkey.operation(item), common_multiple)
            target = rem(level, monkey.divisible) == 0 ? monkey.iftrue : monkey.iffalse
            push!(monkeys[target+1].items, level)
        end
    end
    inspected = monkeys .|> m -> m.inspected
    partialsort!(inspected, 1:2, rev=true)
    return inspected[1] * inspected[2]
end

lines = readlines("day11.txt")
println(day11(Val(:part1), lines, 20))     # 57838
println(day11(Val(:part2), lines, 10_000)) # 15050382231
