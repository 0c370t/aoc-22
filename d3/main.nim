import std/strutils
import std/sequtils
import std/math

let f = open("./input.txt")

var line: string
var sharedItems: seq[char] = @[]

proc getValueOfItem(item: char): int=
    let rawValue = int(item)
    if rawValue >= 97:
        # Lowercase
        let value = rawValue - 96
        return value
    elif rawValue >= 65:
        # Uppercase
        let value = rawValue - 38
        return value

proc lineToSet(l: string): set[char]=
    var o: set[char] = {}
    for c in l:
        o = o + {c}
    return o

proc partTwo(): void=
    var group: array[3, string] = ["","",""]
    var groupMemIdx = 0
    var result = 0
    while not endOfFile(f):
        line = f.readLine()
        group[groupMemIdx] = line
        
        if groupMemIdx == 2:
            # Do the math
            groupMemIdx = 0
            echo group
            var finalSet: set[char] = lineToSet(group[0]) * lineToSet(group[1]) * lineToSet(group[2])
            echo finalSet
            for c in finalSet:
                result = result + getValueOfItem(c)
        else:
            groupMemIdx += 1


    echo result


proc partOne(): void=
    while not endOfFile(f):
        line = f.readLine()

        let midpoint = int(floor(line.len() / 2))
        let first = line.substr(0, midpoint - 1)
        let second = line.substr(midpoint, line.len())

        assert first.len() == second.len()
        assert (first & second) == line

        var firstItems: set[char] = lineToSet(first)
        var secondItems: set[char] = lineToSet(second)

        let intersection: set[char] = firstItems * secondItems
        var v = 0
        for i in intersection: v = v + getValueOfItem(i)

        echo line, " -> ", intersection, " worth ", v

        sharedItems.add(intersection.toSeq())

    var output = 0

    echo sharedItems.len()

    echo "|=---------------------=|"
    echo "|=- Results           -=|"
    echo "|=---------------------=|"
    echo "|=- c   -> v     o    -=|"
    for item in sharedItems:
        let value = getValueOfItem(item)
        output = output + value
        echo "|=- ", item, "  -> ", alignLeft(value.intToStr(), 4)," = ", alignLeft(output.intToStr(), 4), " -=|"
    echo "|=---------------------=|"
    echo output

partTwo()