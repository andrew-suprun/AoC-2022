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

    # part 1: 
    part1 = 0
    for i in 20:40:length(trace)
        part1 += i * trace[i]
    end
    println("Part 1: $part1") # 14620

    # part 2:
    print("Part 2:") # BJFRHRFU
    for (cycle, x) in enumerate(trace)
        pos = rem(cycle - 1, 40)
        if pos == 0
            println()
        end
        if abs(pos - x) <= 1
            print("#")
        else
            print(" ")
        end
    end
    println()
end

day10(readlines("day10.txt"))