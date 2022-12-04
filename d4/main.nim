import std/strutils
import std/sequtils

let f = open("./input.txt")

var total = 0
while not endOfFile(f):
    var line = f.readLine()
    var parts = line.split(",")
    var firstRange = parts[0].split("-").mapIt(parseInt(it))
    var secondRange = parts[1].split("-").mapIt(parseInt(it))

    var firstContainsSecond = min(firstRange) <= min(secondRange) and max(firstRange) >= max(secondRange)
    var secondContainsFirst = min(secondrange) <= min(firstRange) and max(secondRange) >= max(firstRange)

    var overlaps = ((min(firstRange) >= min(secondRange) and min(firstRange) <= max(secondRange)) or
                    (max(firstRange) >= min(secondRange) and max(firstRange) <= max(secondRange)) or
                    (min(secondRange) >= min(firstRange) and min(secondRange) <= max(firstRange)) or
                    (max(secondRange) >= min(firstRange) and max(secondRange) <= max(firstRange)))


    echo firstRange
    echo secondRange
    echo firstContainsSecond, " ", secondContainsFirst
    echo ""

    if firstContainsSecond or secondContainsFirst or overlaps:
        total = total + 1

echo total