mutable struct Dir
    name::String
    subdirs::Vector{Dir}
    size::Int
    parent::Union{Nothing,Dir}

    Dir(name; parent=nothing) = new(name, Vector{Dir}(), 0, parent)
end

function parse_command(line, wd)
    cmd_line = split(line, ' ')
    if cmd_line[2] == "cd"
        name = cmd_line[3]
        if name == ".."
            wd = wd.parent
        elseif name != "/"
            subdir = Dir(name, parent=wd)
            push!(wd.subdirs, subdir)
            wd = subdir
        end
    end
    return wd
end

function parse_file(line, wd)
    (size,) = split(line, " ")
    wd.size += parse(Int, size)
end

function parse_input(path)
    root = Dir("/")
    wd = root
    for line in readlines(path)
        if startswith(line, "\$ ")
            wd = parse_command(line, wd)
        elseif !startswith(line, "dir")
            parse_file(line, wd)
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

function print_tree(dir; level=0)
    println("$("    "^level)$(dir.name): $(dir.size)")
    for subdir in dir.subdirs
        print_tree(subdir, level=level + 1)
    end
end

function part1(dir)
    total = 0
    for subdir in dir.subdirs
        if subdir.size <= 100000
            total += subdir.size
        end
        total += part1(subdir)
    end
    return total

end

function part2(dir, min_size, max_size)
    for subdir in dir.subdirs
        if subdir.size >= min_size && subdir.size < max_size
            max_size = subdir.size
        end
        max_size = part2(subdir, min_size, max_size)
    end
    return max_size
end

function day07(path)
    root = parse_input(path)
    total_size(root)
    print_tree(root)

    println(part1(root)) # 1325919

    println(part2(root, root.size - 40_000_000, 70_000_000)) # 2050735
end

day07("day07.txt")