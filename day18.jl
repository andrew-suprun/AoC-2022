const vacuum = 0
const air = 1
const lava = 2

function dimentions(cubes)
    xmax = ymax = zmax = typemin(Int)
    for (x, y, z) in cubes
        xmax < x && (xmax = x)
        ymax < y && (ymax = y)
        zmax < z && (zmax = z)
    end
    return xmax, ymax, zmax
end

vacuum_inner_space(_scanner, ::Val{:part1}) = nothing
inflate(_scanner, ::Val{:part1}) = nothing

function vacuum_inner_space(scanner, ::Val{:part2})
    for z in 2:size(scanner, 3)-1, y in 2:size(scanner, 2)-1, x in 2:size(scanner, 1)-1
        scanner[x, y, z] = vacuum
    end
end

function inflate(scanner, ::Val{:part2})
    while true
        added_air = 0
        for z in 2:size(scanner, 3)-1, y in 2:size(scanner, 2)-1, x in 2:size(scanner, 1)-1
            if scanner[x, y, z] == vacuum && (
                scanner[x-1, y, z] == air ||
                scanner[x+1, y, z] == air ||
                scanner[x, y-1, z] == air ||
                scanner[x, y+1, z] == air ||
                scanner[x, y, z-1] == air ||
                scanner[x, y, z+1] == air)
                scanner[x, y, z] = air
                added_air += 1
            end
        end
        added_air == 0 && break
    end
end

function day18(lines, part)
    cubes = split.(lines, ',') .|> x -> parse.(Int, x)
    xmax, ymax, zmax = dimentions(cubes)
    scanner = fill(air, xmax + 3, ymax + 3, zmax + 3)
    vacuum_inner_space(scanner, part)
    for cube in cubes
        scanner[cube[1]+2, cube[2]+2, cube[3]+2] = lava
    end
    inflate(scanner, part)
    total = 0
    for z in 2:zmax+2, y in 2:ymax+2, x in 2:xmax+2
        if scanner[x, y, z] == lava
            total += (scanner[x-1, y, z] == air) +
                     (scanner[x+1, y, z] == air) +
                     (scanner[x, y-1, z] == air) +
                     (scanner[x, y+1, z] == air) +
                     (scanner[x, y, z-1] == air) +
                     (scanner[x, y, z+1] == air)
        end
    end
    return total
end

lines = readlines("day18.txt")
println(day18(lines, Val(:part1))) # 3412
println(day18(lines, Val(:part2))) # 2018