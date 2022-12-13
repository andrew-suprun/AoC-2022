function tokenize(line)
    tokens = Vector{Union{Int,Symbol}}()
    start_number = 0
    for i in eachindex(line)
        ch = line[i]
        if ch ≥ '0' && ch ≤ '9'
            if start_number == 0
                start_number = i
            end
        end
        if (ch < '0' || ch > '9') && start_number > 0
            push!(tokens, parse(Int, line[start_number:i-1]))
            start_number = 0
        end
        if line[i] == '['
            push!(tokens, :open)
        elseif line[i] == ']'
            push!(tokens, :close)
        end
    end
    return tokens
end

function isless(left_source::Vector{Union{Int,Symbol}}, right_source::Vector{Union{Int,Symbol}})
    left = copy(left_source)
    right = copy(right_source)
    left_index = right_index = 1
    while true
        left_token = left[left_index]
        right_token = right[right_index]
        if left_token == :open
            if right_token == :open
                left_index += 1
                right_index += 1
                continue
            elseif right_token == :close
                return false
            else
                insert!(right, right_index, :open)
                insert!(right, right_index + 2, :close)
                continue
            end
        elseif left_token == :close
            if right_token == :open
                return true
            elseif right_token == :close
                left_index += 1
                right_index += 1
                continue
            else
                return true
            end
        else
            if right_token == :open
                insert!(left, left_index, :open)
                insert!(left, left_index + 2, :close)
                continue
            elseif right_token == :close
                return false
            else
                if left_token < right_token
                    return true
                elseif left_token > right_token
                    return false
                else
                    left_index += 1
                    right_index += 1
                    continue
                end
            end
        end
    end
    return true
end

function day13a(lines)
    sum = 0
    j = 0
    for i in 1:3:length(lines)
        inorder = isless(tokenize(lines[i]), tokenize(lines[i+1]))
        j += 1
        sum += j * inorder
    end
    return sum
end

function day13b(lines)
    tokens_two = tokenize("[[2]]")
    tokens_six = tokenize("[[6]]")
    token_lines = map(tokenize, filter(l -> l != "", lines))
    push!(token_lines, tokens_two, tokens_six)
    sort!(token_lines, lt=isless)
    return prod(i for (i, tokens) in enumerate(token_lines) if tokens == tokens_two || tokens == tokens_six)
end

using BenchmarkTools
lines = readlines("day13.txt")
println(@btime day13a(lines))
println(@btime day13b(lines))

#   395.917 μs (7907 allocations: 754.98 KiB)
# 5013
#   800.167 μs (14749 allocations: 5.05 MiB)
# 25038