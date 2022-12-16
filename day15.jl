struct Position
    x::Int
    y::Int
end

distance(pos1, pos2) = abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)

struct Sensor
    sensor::Position
    beacon::Position
end

struct Ranges
    ranges::Vector{UnitRange{Int}}
    Ranges() = new(UnitRange{Int}[])
end

function Base.push!(ranges::Ranges, range::UnitRange{Int})
    while true
        found_overlap = false
        for (i, inner) in enumerate(ranges.ranges)
            if !(inner.stop ≤ range.start - 2 || range.stop ≤ inner.start - 2)
                deleteat!(ranges.ranges, i)
                found_overlap = true
                range = min(inner.start, range.start):max(inner.stop, range.stop)
                break
            end
        end
        if !found_overlap
            push!(ranges.ranges, range)
            break
        end
    end
end

Base.length(r::Ranges) = sum(length.(r.ranges))

function read_input(lines)
    sensors = Sensor[]
    for line in lines
        line = replace(line, "Sensor at x=" => "", ": closest beacon is at x=" => ",", ", y=" => ",")
        sx, sy, bx, by = parse.(Int, split(line, ","))
        push!(sensors, Sensor(Position(sx, sy), Position(bx, by)))
    end

    return sensors
end

function cover(sensors, y)
    covered = Ranges()
    for sensor in sensors
        diff = distance(sensor.sensor, sensor.beacon) - abs(sensor.sensor.y - y)
        diff ≥ 0 && push!(covered, sensor.sensor.x-diff:sensor.sensor.x+diff)
    end
    return covered
end

function day15a(lines, nline)
    sensors = read_input(lines)
    inline_beacons = Set(Position[])
    for sensor in sensors
        sensor.beacon.y == nline && push!(inline_beacons, sensor.beacon)
    end
    return length(cover(sensors, nline)) - length(inline_beacons)
end

function day15b(lines, size)
    sensors = read_input(lines)
    for y in 0:size
        covered = cover(sensors, y)
        if length(covered.ranges) == 2
            if covered.ranges[1].start > covered.ranges[2].start
                covered.ranges[1], covered.ranges[2] = covered.ranges[2], covered.ranges[1]
            end
            return (covered.ranges[1].stop + 1) * size + y
        end
    end
end

lines = readlines("day15.txt")
println(day15a(lines, 2_000_000)) #        5181556  (25.166 μs)
println(day15b(lines, 4_000_000)) # 12817603219131 (364.338 ms)
