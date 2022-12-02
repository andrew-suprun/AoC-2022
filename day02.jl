day02(path, scores) = println(sum(scores[line] for line in readlines(path)))

# part 1
day02("day02.txt", Dict("A X" => 4, "A Y" => 8, "A Z" => 3, "B X" => 1, "B Y" => 5, "B Z" => 9, "C X" => 7, "C Y" => 2, "C Z" => 6))

# part 2
day02("day02.txt", Dict("A X" => 3, "A Y" => 4, "A Z" => 8, "B X" => 1, "B Y" => 5, "B Z" => 9, "C X" => 2, "C Y" => 6, "C Z" => 7))
