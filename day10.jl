function day10(lines)
    trace = [1]

    for line in lines
        (code, params...) = split(line)
        if code == "noop"
            push!(trace, trace[end])
        elseif code == "addx"
            push!(trace, trace[end])
            push!(trace, trace[end] + parse(Int, params[1]))
        end
    end

    part1 = sum(i * trace[i] for i in 20:40:length(trace))
    println("Part 1: $part1") # 14620

    # part 2:
    print("Part 2:") # BJFRHRFU
    for (cycle, x) in enumerate(trace)
        pos = rem(cycle - 1, 40)
        pos == 0 && println()
        abs(pos - x) <= 1 ? print("██") : print("  ")
    end
    println()
end

day10(readlines("day10.txt"))