import sequtils
import strutils, strformat

let f = open("./input.txt")

var forest = newSeq[seq[int]]()
var mask = newSeq[seq[int]]()

while not endOfFile(f):
    let line = f.readLine()
    var lineSeq = newSeq[int]()
    var maskSeq = newSeq[int]()
    for c in line:
        var parsedResult = parseInt("" & c)
        lineSeq.add(parsedResult)
        maskSeq.add(0)

    forest.add(lineSeq)
    mask.add(maskSeq)

proc canSeeToEdge(s: seq[int], v: int, vIdx: int): (bool, int, int) =
    var left = true
    var right = true
    var visCountL = 0
    var visCountR = 0
    
    assert s[vIdx] == v

    # Scan left
    for i in countdown(vIdx-1, 0):
        assert i != vIdx
        visCountL += 1
        if s[i] >= v:
            left = false
            break
        
    # Scan right
    for i in vIdx+1..s.len()-1:
        assert i != vIdx
        visCountR += 1
        if s[i] >= v:
            right = false
            break

    return (left or right, visCountL, visCountR)

var partOne = 0

for xIdx, row in forest:
    for yIdx, height in row:
        let col = forest.mapIt(it[yIdx])
        # echo fmt"({xIdx}, {yIdx}), {height} [{row[yIdx]}|{col[xIdx]}]"

        assert row[yIdx] == height
        assert col[xIdx] == height
        let (tallestInRow, rVisL, rVisR) = canSeeToEdge(row, height, yIdx)
        let (tallestInCol, cVisU, cVisD) = canSeeToEdge(col, height, xIdx)

        if tallestInCol or tallestInRow:
            partOne += 1
        
        mask[xIdx][yIdx] = rVisL * rvisR * cVisU * cVisD
        
        # echo fmt"{xIdx}, {yIdx}, {height} || {rVisL} | {rVisR} | {cVisD} | {cVisU} || {mask[xIdx][yIdx]}"

echo partOne

echo max(mask.mapIt(max(it)))
