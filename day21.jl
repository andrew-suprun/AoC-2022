struct Operation
    operand1::String
    operand2::String
    operation::String
end

function get_input(lines)
    input = Dict{String,Union{Int,Operation}}()
    for line in split.(replace.(lines, ":" => ""))
        if length(line) == 4
            input[line[1]] = Operation(line[2], line[4], line[3])
        else
            input[line[1]] = parse(Int, line[2])
        end
    end
    return input
end

function eval(monkey::String, input)
    value = input[monkey]
    value isa Int && return value
    op1 = eval(value.operand1, input)
    op2 = eval(value.operand2, input)
    op = value.operation
    return if op == "+"
        op1 + op2
    elseif op == "-"
        op1 - op2
    elseif op == "*"
        op1 * op2
    else
        op1 ÷ op2
    end
end

day21a(input) = eval("root", input)

function day21b(input)
    path = ["humn"]
    while true
        for (name, op) in input
            if op isa Operation && (op.operand1 == path[1] || op.operand2 == path[1])
                pushfirst!(path, name)
                break
            end
        end
        if path[1] == "root"
            break
        end
    end

    op1, op2 = input["root"].operand1, input["root"].operand2
    expected = if op1 == path[2]
        eval(op2, input)
    else
        eval(op1, input)
    end

    for i in eachindex(path[1:end-2])
        operation = input[path[i+1]]
        op = operation.operation
        if path[i+2] == operation.operand1
            op2 = eval(operation.operand2, input)
            if op == "+"
                expected -= op2
            elseif op == "-"
                expected += op2
            elseif op == "*"
                expected ÷= op2
            elseif op == "/"
                expected *= op2
            end
        else
            op1 = eval(operation.operand1, input)
            if op == "+"
                expected -= op1
            elseif op == "-"
                expected = op1 - expected
            elseif op == "*"
                expected ÷= op1
            elseif op == "/"
                expected = op1 ÷ expected
            end
        end
    end
    return expected
end

input = get_input(readlines("day21.txt"))
println("Part 1: $(day21a(input))") # 54703080378102
println("Part 2: $(day21b(input))") #  3952673930912