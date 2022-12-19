using .Iterators

const rocks = [
    [(0, 0), (1, 0), (2, 0), (3, 0)],
    [(1, 0), (0, 1), (1, 1), (2, 1), (1, 2)],
    [(0, 0), (1, 0), (2, 0), (2, 1), (2, 2)],
    [(0, 0), (0, 1), (0, 2), (0, 3)],
    [(0, 0), (1, 0), (0, 1), (1, 1)]]

mutable struct Chamber
    rocks::Vector{Vector{Bool}}
    rock_iter::Iterators.Stateful
    wind_iter::Iterators.Stateful
    rock::Int
    x::Int
    y::Int
    function Chamber(winds::String)
        chamber = new(Vector{Int8}[], Iterators.Stateful(cycle(1:5)), Iterators.Stateful(cycle(winds)), 0, 3, 4)
        chamber.rock = popfirst!(chamber.rock_iter)
        return chamber
    end
end

Base.length(chamber::Chamber) = length(chamber.rocks)

Base.getindex(ch::Chamber, x::Int, y::Int) = y ≤ length(ch.rocks) && ch.rocks[y][x]

function Base.setindex!(ch::Chamber, value::Bool, x::Int, y::Int)
    while y > length(ch.rocks)
        push!(ch.rocks, falses(7))
    end
    ch.rocks[y][x] = value
    return value
end

function check_sideway_move(chamber::Chamber, xdiff::Int)
    for tile in rocks[chamber.rock]
        x = chamber.x + tile[1] + xdiff
        y = chamber.y + tile[2]
        if x == 0 || x == 8 || (y ≤ length(chamber) && chamber[x, y])
            return false
        end
    end
    return true
end

function check_downward_move(chamber::Chamber)
    for tile in rocks[chamber.rock]
        x = chamber.x + tile[1]
        y = chamber.y + tile[2] - 1
        if y == 0 || (y ≤ length(chamber) && chamber[x, y])
            return false
        end
    end
    return true
end

function freeze_rock!(chamber::Chamber)
    for tile in rocks[chamber.rock]
        chamber[chamber.x+tile[1], chamber.y+tile[2]] = true
    end
    chamber.rock = popfirst!(chamber.rock_iter)
    chamber.x, chamber.y = 3, length(chamber) + 4
end

function drop_rock!(chamber::Chamber)
    while true
        wind = popfirst!(chamber.wind_iter)
        xdiff = wind == '<' ? -1 : 1
        if check_sideway_move(chamber, xdiff)
            (chamber.x += xdiff)
        end
        if check_downward_move(chamber)
            chamber.y -= 1
        else
            break
        end
    end
    freeze_rock!(chamber)
end

function day17a(line)
    chamber = Chamber(line)
    for _ in 1:2022
        drop_rock!(chamber)
    end
    return length(chamber)
end

function day17b(line)
    chamber = Chamber(line)
    period = 0
    slice = Vector{Bool}[]

    for _ in 1:1_000_000_000_000
        drop_rock!(chamber)
        period = length(chamber) ÷ 4
        if period > 20 && chamber.rocks[period:2period-1] == chamber.rocks[2period:3period-1]
            slice = copy(chamber.rocks[period:2period-1])
            break
        end
    end

    total_rocks = 0
    chamber = Chamber(line)
    for i in 1:1_000_000_000_000
        drop_rock!(chamber)
        total_rocks += 1

        if length(chamber) ≥ 2period - 1
            if slice == chamber.rocks[period:2period-1]
                rocks = i
                break
            end
        end
    end
    rocks_period = 0
    for i in 1:1_000_000_000_000
        drop_rock!(chamber)
        rocks_period += 1
        total_rocks += 1

        if length(chamber) ≥ 3period - 1
            if slice == chamber.rocks[2period:3period-1]
                break
            end
        end
    end
    periods = (1_000_000_000_000 - total_rocks) ÷ rocks_period
    rocks_to_drop = 1_000_000_000_000 - (rocks_period * periods + total_rocks)
    for i in 1:rocks_to_drop
        drop_rock!(chamber)
    end
    return length(chamber) + periods * period
end

line = readline("day17.txt")
println(day17a(line)) # 3117
println(day17b(line)) # 1_553_314_121_019
