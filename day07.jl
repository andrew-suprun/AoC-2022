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

function walk_tree(f, dir; level=0)
    f(dir, level)
    for subdir in dir.subdirs
        walk_tree(f, subdir, level=level + 1)
    end
end

function print_tree(root)
    walk_tree(root) do dir, level
        println("$("    "^level)$(dir.name): $(dir.size)")
    end
end

function part1(root)
    total = 0
    walk_tree(root) do dir, _
        if dir.size <= 100000
            total += dir.size
        end
    end
    println("part 1: $total")
end

function part2(root, min_size)
    size = 70_000_000
    walk_tree(root) do dir, _
        if dir.size > min_size && dir.size < size
            size = dir.size
        end
    end
    println("part 2: $size")
end

root = parse_input("day07.txt")
total_size(root)
print_tree(root)

part1(root)                         # 1325919
part2(root, root.size - 40_000_000) # 2050735