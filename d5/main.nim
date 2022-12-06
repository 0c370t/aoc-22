import std/re
import std/math
import std/deques
import std/sequtils
import std/strutils
import std/strformat

var f = open("./input.txt")

var cargo = newSeqWith[Deque[char]](9, newSeq[char]().toDeque())

const pt2 = true

proc printCrates(allCrates: seq[Deque[char]]): void=
    return
    let maxIdx = max(cargo.mapIt(it.len()))
    for i in countdown(maxIdx - 1, 0):
        var line = ""
        for c in cargo:
            if c.len() <= i or c[i] == ' ': 
                line = line & "    "
                continue
            
            line = line & fmt"[{c[i]}] "
        echo line
    var line = ""
    for i in 0..cargo.len():
        line = line & fmt" {i+1}  "
    echo line
    echo "\n|=------------------------------------=|"

# Read Containers
while not endOfFile(f):
    let line = f.readLine()
    if line == "" or line[1] == '1': 
        discard f.readLine() # discard blank line
        break

    var i = 0
    var cargoIdx = 0
    while i < line.len():
        let t = line[i + 1]
        if t != ' ':
            cargo[cargoIdx].addFirst(t)
        i = i + 4
        cargoIdx = cargoIdx + 1

var regx = re"move ([\d]+) from ([\d]+) to ([\d]+)"

const before = "BEFORE"
const after = "AFTER"
# echo "\n|=------------------------------------=|"
# Perform Operations

while not endOfFile(f):
    let line = f.readLine()
    var matches: array[3, string]
    discard match(line, regx, matches)
    let moves = matches.map(parseInt)
    # echo fmt"|= {alignLeft(line, 33)} -=|"
    var source = cargo[moves[1] - 1]
    var dest = cargo[moves[2] - 1]

    # echo fmt"|= {alignLeft(before, 33)} -=|"
    printCrates(cargo)


    if pt2:
        var tmp = newSeq[char]().toDeque()
        for i in 0..moves[0] - 1:
            let f = source.popLast()
            tmp.addFirst(f)

        for c in tmp:
            dest.addLast(c)
    else:
        for i in 0..moves[0] - 1:
            let f = source.popLast()
            dest.addLast(f)


    cargo[moves[1] - 1] = source
    cargo[moves[2] - 1] = dest
 
    # echo fmt"|= {alignLeft(after, 33)} -=|"
    printCrates(cargo)

printCrates(cargo)

echo cargo.filterIt(it.len() > 0).mapIt(it.peekLast()).join("")
