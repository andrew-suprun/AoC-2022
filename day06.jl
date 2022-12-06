function day06(marker_length)
    line = readline("day06.txt")
    for i in 1:length(line)-marker_length+1
        if length(unique(line[i:i+marker_length-1])) == marker_length
            println(i + marker_length - 1)
            break
        end
    end
end

day06(4)
day06(14)

