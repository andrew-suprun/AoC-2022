mutable struct Dir
    subdirs::Vector{Dir}
    size::Int
    parent::Union{Nothing,Dir}

    Dir(; parent=nothing) = new(Vector{Dir}(), 0, parent)
end

function parse_input(lines)
    root = Dir()
    wd = root
    for line in lines
        cmd_line = split(line, ' ')
        if cmd_line[1] == "\$"
            if cmd_line[2] == "cd"
                if cmd_line[3] == ".."
                    wd = wd.parent
                elseif cmd_line[3] != "/"
                    subdir = Dir(parent=wd)
                    push!(wd.subdirs, subdir)
                    wd = subdir
                end
            end
        elseif !startswith(line, "dir")
            wd.size += parse(Int, cmd_line[1])
        end
    end
    return root
end

function total_size(dir)
    for subdir in dir.subdirs
        dir.size += total_size(subdir)
    end
    return dir.size
end

function walk_tree(f, dir)
    f(dir)
    for subdir in dir.subdirs
        walk_tree(f, subdir)
    end
end

function part1(root)
    total = 0
    walk_tree(root) do dir
        if dir.size <= 100000
            total += dir.size
        end
    end
    return total
end

function part2(root, min_size)
    size = 70_000_000
    walk_tree(root) do dir
        if dir.size > min_size && dir.size < size
            size = dir.size
        end
    end
    return size
end

lines = readlines("day07.txt")
root = parse_input(lines)
total_size(root)

println("Part 1: $(part1(root))")                         # 1325919
println("Part 2: $(part2(root, root.size - 40_000_000))") # 2050735