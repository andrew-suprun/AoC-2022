function day01(path)
    totals = Vector{Int}()
    total = 0
    for line in readlines(path)
        if line == ""
            push!(totals, total)
            total = 0
        else
            total += parse(Int, line)
        end
    end
    push!(totals, total)
    partialsort!(totals, 3, rev=true)
    return totals[1], sum(totals[1:3])
end

println(day01(ARGS[1]))

