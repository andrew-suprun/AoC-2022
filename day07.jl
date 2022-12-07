mutable struct Dir
    dirs::Vector{Dir}
    files::Vector{Int}
    parent::Union{Nothing,Dir}
    Dir(; parent=nothing) = new(Vector{Dir}(), Vector{Tuple{String,Int}}(), parent)
end

function command(line, pwd)
    cmd_line = split(line, ' ')
    if cmd_line[2] == "cd"
        name = cmd_line[3]
        if name == "/"
            while pwd.parent !== nothing
                pwd = pwd.parent
            end
        elseif name == ".."
            pwd = pwd.parent
        else
            subdir = Dir(parent=pwd)
            push!(pwd.dirs, subdir)
            pwd = subdir
        end
    end
    return pwd
end

function file(line, pwd)
    (size, _) = split(line, " ")
    push!(pwd.files, parse(Int, size))
end

function scan(dir)
    total = 0
    for file in dir.files
        total += file
    end
    for subdir in dir.dirs
        size = scan(subdir)
        total += size
    end
    return total
end

function walk_dirs(dir)
    total = 0
    for subdir in dir.dirs
        size = scan(subdir)
        if size <= 100000
            total += size
        end
        total += walk_dirs(subdir)
    end
    return total
end

function find_suitable(dir, min_size)
    total = 70_000_000
    for subdir in dir.dirs
        size = scan(subdir)
        if size >= min_size && size < total
            total = size
        end
    end
    for subdir in dir.dirs
        size = find_suitable(subdir, min_size)
        if size >= min_size && size < total
            total = size
        end
    end
    return total
end

function day07()
    root = Dir()
    pwd = root
    for line in readlines("day07.txt")
        if startswith(line, "\$ ")
            pwd = command(line, pwd)
        elseif !startswith(line, "dir")
            file(line, pwd)
        end
    end

    # part 1
    println(walk_dirs(root))

    # part 2
    println(find_suitable(root, scan(root) - 40_000_000))
end

day07()
