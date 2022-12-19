function parse_input(lines)
    valves = Dict{String,Int}()
    pipes = Dict{String,Vector{String}}()
    for line in lines
        line = replace(line,
            "Valve " => "",
            " has flow rate=" => " ",
            "; tunnels lead to valves " => " ",
            "; tunnel leads to valve " => " ", ", " => ",",
            ", " => ",")
        source, valve_str, target_list = split(line, " ")
        valve = parse(Int, valve_str)
        valves[source] = valve
        pipes[source] = split(target_list, ",")
    end

    times = Dict{String,Vector{Tuple{String,Int}}}()
    for (source, valve) in valves
        if source != "AA" && valve == 0
            continue
        end
        source_times = Tuple{String,Int}[]
        visited = Set{String}()
        to_visit = [(source, 0)]
        for _ in 1:7
            next_to_visit = Tuple{String,Int}[]
            for visit in to_visit
                if visit[1] in visited
                    continue
                end
                if visit[2] > 0 && valves[visit[1]] > 0
                    push!(source_times, visit)
                end

                push!(visited, visit[1])
                for target in pipes[visit[1]]
                    if target[1] in visited
                        continue
                    end
                    push!(next_to_visit, (target, visit[2] + 1))
                end
            end
            if isempty(next_to_visit)
                break
            end
            to_visit = next_to_visit
        end
        push!(source_times, ("STOP", 100))
        times[source] = source_times
    end
    return valves, times
end

struct Actor
    target::String
    timer::Int
end

function day16(lines, actor1, actor2)
    valves, times = parse_input(lines)
    visited = Set{String}()
    function walk_tree(actor1::Actor, actor2::Union{Actor,Nothing}, score::Int, level)
        if actor2 !== nothing && actor1.timer < actor2.timer
            actor1, actor2 = actor2, actor1
        end
        actor1.timer ≤ 0 && return score
        score += valves[actor1.target] * actor1.timer
        max_score = score
        for target in times[actor1.target]
            target[1] in visited && continue
            push!(visited, target[1])
            tree_score = walk_tree(Actor(target[1], actor1.timer - target[2] - 1), actor2, score, level + 1)
            max_score = max(max_score, tree_score)
            delete!(visited, target[1])
        end
        return max_score
    end
    return walk_tree(actor1, actor2, 0, 0)
end

lines = readlines("day16.txt")
# println("Part 1:$(day16(lines, Actor("AA", 30), nothing))")         # 1880
# println("Part 2:$(day16(lines, Actor("AA", 26), Actor("AA", 26)))") # 2520
