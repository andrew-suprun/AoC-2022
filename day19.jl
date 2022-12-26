struct Blueprint
    id::Int
    costs::NTuple{4,NTuple{4,Int}}
end

struct State
    timer::Int
    robots::NTuple{4,Int}
    resources::NTuple{4,Int}
end

struct Move
    robot::Int
    timer::Int
end

const robot_selector = ((1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1))

function parse_input(lines)
    strategies = Blueprint[]
    for line in lines
        line = replace(line,
            "Blueprint " => "",
            ": Each ore robot costs " => " ",
            " ore. Each clay robot costs " => " ",
            " ore. Each obsidian robot costs " => " ",
            " ore and " => " ",
            " clay. Each geode robot costs " => " ",
            " obsidian." => "",
        )
        fields = split(line)
        s = parse.(Int, fields)
        blueprint = Blueprint(s[1], (
            (s[2], 0, 0, 0),
            (s[3], 0, 0, 0),
            (s[4], s[5], 0, 0),
            (s[6], 0, s[7], 0)))
        push!(strategies, blueprint)
    end
    return strategies
end

function max_value(blueprint, timer)
    limits = (
        max(blueprint.costs[1][1], blueprint.costs[2][1], blueprint.costs[3][1], blueprint.costs[4][1]),
        blueprint.costs[3][2],
        blueprint.costs[4][3],
        typemax(Int))

    function possible_moves(state::State)
        result = Move[]
        for robot in 4:-1:1
            if limits[robot] > state.robots[robot]
                max_timer = 0
                possible = true
                for (i, cost) in enumerate(blueprint.costs[robot])
                    if cost != 0
                        if state.robots[i] == 0
                            possible = false
                            break
                        else
                            max_timer = max(max_timer, (cost - state.resources[i] + state.robots[i] - 1) ÷ state.robots[i])
                        end
                    end
                end
                if possible
                    push!(result, Move(robot, max_timer))
                end
            end
        end
        return result
    end

    next_state(state::State, move::Move) = State(
        state.timer - move.timer - 1,
        state.robots .+ robot_selector[move.robot],
        state.resources .+ state.robots .* (move.timer + 1) .- blueprint.costs[move.robot])

    function walk_tree(state::State)
        geodes = 0
        for move in possible_moves(state)
            if move.timer ≥ state.timer
                geodes = max(geodes, state.resources[4] + state.timer * state.robots[4])
                continue
            end
            geodes = max(geodes, walk_tree(next_state(state, move)))
        end
        return geodes
    end

    return walk_tree(State(timer, (1, 0, 0, 0), (0, 0, 0, 0)))
end

day19a(lines) = sum(max_value(blueprint, 24) * blueprint.id for blueprint in parse_input(lines))
day19b(lines) = prod(max_value(blueprint, 32) for blueprint in parse_input(lines)[1:3])

lines = readlines("day19.txt")
println("Part 1: $(day19a(lines))") # 1266
println("Part 2: $(day19b(lines))") # 5800
