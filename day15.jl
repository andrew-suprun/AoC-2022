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

function day15part end

function day15(part, lines, line, size)
    sensors = Sensor[]
    for line in lines
        parts = split(line, "Sensor at x=")
        parts = split(parts[2], ": closest beacon is at x=")
        sensor = split(parts[1], ", y=")
        beacon = split(parts[2], ", y=")
        sensorx, sensory = parse.(Int, sensor)
        beaconx, beacony = parse.(Int, beacon)
        push!(sensors, Sensor(Position(sensorx, sensory), Position(beaconx, beacony)))
    end

    return day15part(part, sensors, line, size)
end

function day15part(::Val{:part1}, sensors, line, _size)
    covered = Ranges()
    for sensor in sensors
        beacon_dustance = distance(sensor.sensor, sensor.beacon)
        diff = beacon_dustance - abs(sensor.sensor.y - line)
        if diff ≥ 0
            push!(covered, sensor.sensor.x-diff:sensor.sensor.x+diff)
        end
    end
    ncovered = length(covered)
    inline_beacons = Set(Position[])
    for sensor in sensors
        if sensor.beacon.y == line
            push!(inline_beacons, sensor.beacon)
        end
    end
    ncovered -= length(inline_beacons)
    return ncovered
end

function day15part(::Val{:part2}, sensors, _line, size)
    for y in 0:size
        covered = Ranges()
        for sensor in sensors
            beacon_dustance = distance(sensor.sensor, sensor.beacon)
            diff = beacon_dustance - abs(sensor.sensor.y - y)
            if diff ≥ 0
                push!(covered, sensor.sensor.x-diff:sensor.sensor.x+diff)
            end
        end
        if length(covered.ranges) == 2
            if covered.ranges[1].start == covered.ranges[2].stop + 2
                return (covered.ranges[1].start - 1) * size + y
            elseif covered.ranges[2].start == covered.ranges[2].stop + 2
                return (covered.ranges[2].start - 1) * size + y
            end
        end
    end
    return 0
end

lines = readlines("day15.txt")
println(day15(Val(:part1), lines, 2_000_000, 4_000_000)) #        5181556  (25.166 μs)
println(day15(Val(:part2), lines, 2_000_000, 4_000_000)) # 12817603219131 (364.338 ms)
