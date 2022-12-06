function day06(marker_length)
    line = readline("day06.txt")
    for i in 1:length(line)+marker_length-1
        c4 = line[i:i+marker_length-1]
        if length(unique(c4)) == marker_length
            @show i + marker_length - 1
            break
        end
    end
end

day06(4)
day06(14)

