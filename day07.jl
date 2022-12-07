mutable struct Dir
    name::String
    subdirs::Vector{Dir}
    size::Int
    parent::Union{Nothing,Dir}

    Dir(name; parent=nothing) = new(name, Vector{Dir}(), 0, parent)
end

function command(line, wd)
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

function file(line, wd)
    (size, _) = split(line, " ")
    wd.size += parse(Int, size)
end

function parse_input(path)
    root = Dir("/")
    wd = root
    for line in readlines(path)
        if startswith(line, "\$ ")
            wd = command(line, wd)
        elseif !startswith(line, "dir")
            file(line, wd)
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

function sum_small_dirs(dir)
    total = 0
    for subdir in dir.subdirs
        if subdir.size <= 100000
            total += subdir.size
        end
        total += sum_small_dirs(subdir)
    end
    return total

end

function find_suitable_dir(dir, min_size, max_size)
    for subdir in dir.subdirs
        if subdir.size >= min_size && subdir.size < max_size
            max_size = subdir.size
        end
        max_size = find_suitable_dir(subdir, min_size, max_size)
    end
    return max_size
end

function day07(path)
    root = parse_input(path)
    total_size(root)
    print_tree(root)

    # part 1
    println(sum_small_dirs(root))

    # part 2
    println(find_suitable_dir(root, root.size - 40_000_000, 70_000_000))
end

day07("day07.txt")

# ----
# 1325919
# 2050735
# ----