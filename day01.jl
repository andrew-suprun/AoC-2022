# return the tuple of solutions for part1 and part2
function day01(path)
    totals = [0]
    for line in readlines(path)
        if line == ""
            push!(totals, 0)
        else
            totals[end] += parse(Int, line)
        end
    end
    partialsort!(totals, 3, rev=true)
    return totals[1], sum(totals[1:3])
end

println(day01("day01.txt"))

