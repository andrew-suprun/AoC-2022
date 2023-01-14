function from_snafu(s)
    n = 0
    for c in s
        n = 5n + findnext(c, "=-012", 1) - 3
    end
    return n
end

function to_snafu(n)
    d = Int[]
    while n > 0
        prepend!(d, n % 5)
        n ÷= 5
    end
    for i in reverse(eachindex(d))
        if d[i] > 2
            d[i] -= 5
            d[i-1] += 1
        end
    end
    return join(map(i -> "=-012"[i+3], d))
end

part1 = map(from_snafu, readlines("day25.txt")) |> sum |> to_snafu
println("Part 1: $part1") # 20=212=1-12=200=00-1