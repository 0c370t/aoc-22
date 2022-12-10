import strutils, strformat, sequtils
let file = open("./input.txt")


var i = 0
var val = 1

var frameHistory = newSeq[int]()
var buffer = newSeq[seq[bool]]()

while not endOfFile(file):
    let line = file.readLine()
    let parts = line.split(" ")
    echo fmt"[{i}] {val}"
    if parts[0] == "noop":
        val += 0
        frameHistory.add(val)
    elif parts[0] == "addx":
        let v = parseInt(parts[1])
        i += 1
        echo fmt"[{i}] ||| {val} + {v} => {val + v}"
        frameHistory.add(val)
        val += v
        echo fmt"[{i}] {val}"
        frameHistory.add(val)
    else:
        echo "!!!Unexpected Case!!!"
    i += 1

echo val

var str = 0
const frames = [20, 60, 100, 140, 180, 220]

for frame in frames:
    let f = frame - 1
    echo fmt"[{f}] {frameHistory[f-1]}"
    str += frameHistory[f - 1] * frame

echo str

var row = newSeq[bool]()
for idx, frame in frameHistory:
    echo fmt"{frame - 1} <= {idx mod 40} <= {frame + 1}"

    row.add(
        frame - 1 <= (idx + 1) mod 40 and
        frame + 1 >= (idx + 1) mod 40
    )

    if (idx + 1) mod 40 == 0:
        buffer.add(row)
        row = newSeq[bool]()
    
    echo row.mapIt(if it: "X" else: ".").join("")

for r in buffer:
    echo r.mapIt(if it: "X" else: ".").join("")