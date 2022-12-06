import std/deques
import std/sequtils
import std/strutils
import std/strformat

let f = open("./input.txt")
var startQ = newSeqWith(4, ' ').toDeque()
var messageQ = newSeqWith(14, ' ').toDeque()

let line = f.readLine()

for i, c in line:
    startQ.addLast(c)
    discard startQ.popFirst()
    assert startQ.len() == 4
    if startQ.toSeq().deduplicate(false).len() == 4 and i > 3:
        echo fmt"Found Potential Start @ {i + 1} [{startQ}]"
        break

for i, c in line:
    messageQ.addLast(c)
    discard messageQ.popFirst()
    assert messageQ.len() == 14
    if messageQ.toSeq().deduplicate(false).len() == 14 and i > 13:
        echo fmt"Found Potential Message @ {i + 1} [{messageQ}]"
        break