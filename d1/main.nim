import std/algorithm
import std/parseutils
import std/strformat

let f = open("./input.txt")

var line: string
var currentTotal = 0
var totals = newSeq[int]()

while not endOfFile(f):
    line = f.readLine()

    if line == "":
        totals.add(currentTotal)
        currentTotal = 0
        continue

    var amount: int
    discard parseInt(line, amount)

    currentTotal = currentTotal + amount

totals.add(currentTotal)
echo "Totals"

totals.sort()

echo "The man with the most has"
echo totals[totals.len - 1]

echo "The others have"
echo fmt"{totals[totals.len - 1]} {totals[totals.len - 2]} {totals[totals.len - 3]}"
echo totals[totals.len - 1] + totals[totals.len - 2] + totals[totals.len - 3]
