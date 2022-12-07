function day06(marker_length)
    line = readline("day06.txt")
    dict = Dict{Char,Int}()
    for i in 1:marker_length
        if length(dict) == marker_length
            println(i - 1)
            break
        end
        v = get(dict, line[i], 0)
        dict[line[i]] = v + 1
    end

    for i in marker_length+1:length(line)
        if length(dict) == marker_length
            println(i - 1)
            break
        end
        old_char = line[i-marker_length]
        v = dict[old_char]
        if v == 1
            delete!(dict, old_char)
        else
            dict[old_char] = v - 1
        end
        v = get(dict, line[i], 0)
        dict[line[i]] = v + 1
    end
end

day06(4)
day06(14)
