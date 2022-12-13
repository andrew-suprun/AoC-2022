mutable struct List
    items::Vector{Union{List,Int}}

    List() = new(Union{List,Int}[])
    List(i::Int) = new(Union{List,Int}[i])
end

function List(line::String)
    stack = List[]
    start_number = 0
    for (i, ch) in enumerate(line)
        if ch ≥ '0' && ch ≤ '9' && start_number == 0
            start_number = i
        elseif (ch < '0' || ch > '9') && start_number > 0
            push!(stack[end].items, parse(Int, line[start_number:i-1]))
            start_number = 0
        end
        if ch == '['
            push!(stack, List())
        elseif ch == ']'
            top = pop!(stack)
            isempty(stack) && return top
            push!(stack[end].items, top)
        end
    end
    return stack[1]
end

Base.show(io::IO, list::List) = (print(io, "["); join(io, list.items, ","); print(io, "]"))

function Base.isequal(left::List, right::List)
    length(left.items) != length(right.items) && return false
    for (l, r) in zip(left.items, right.items)
        l != r && return false
    end
    return true
end
Base.isequal(l::List, r::Int) = l == List(r)
Base.isequal(l::Int, r::List) = List(l) == r

function Base.isless(left::List, right::List)
    for (l, r) in zip(left.items, right.items)
        l < r && return true
        l > r && return false
    end
    return length(left.items) < length(right.items)
end
Base.isless(l::List, r::Int) = l < List(r)
Base.isless(l::Int, r::List) = List(l) < r

day13a(lines) = sum(i for i in 1:(length(lines)+1)÷3 if List(lines[3i-2]) < List(lines[3i-1]))

function day13b(lines)
    lists = map(List, filter(l -> l != "", lines))
    list2, list6 = List("[[2]]"), List("[[6]]")
    push!(lists, list2, list6)
    sort!(lists)
    return prod(i for (i, list) in enumerate(lists) if list == list2 || list == list6)
end

using BenchmarkTools
lines = readlines("day13.txt")
println(@btime day13a(lines))
println(@btime day13b(lines))

#   473.625 μs (18530 allocations: 704.70 KiB)
# 5013
#   718.125 μs (26097 allocations: 1014.45 KiB)
# 25038