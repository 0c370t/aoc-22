import strutils, std/enumutils, sequtils, terminal

let f = open("./test2.txt")

const knotCount = 10
const debug = false

var knots = newSeq[(int, int)]()
for i in 0..knotCount-1:
    knots.add((0,0))

var history = newSeq[seq[(int, int)]]()
history.add(knots)
var tailPositions = newSeq[(int, int)]()
tailPositions.add(knots[knots.len() - 1])

type
  Direction = enum
    U, D, L, R

proc updateTail(inputHeight: (int, int), inputTail: (int,int)): ((int,int), (int, int))=
    var h = inputHeight
    var t = inputTail

    case h[0] - t[0]:
        of 2:
            t[0] += 1
            t[1] += (if (h[1] - t[1]) > 0: 1 elif (h[1] - t[1]) == 0: 0 else: -1)
        of -2:
            t[0] -= 1
            t[1] += (if (h[1] - t[1]) > 0: 1 elif (h[1] - t[1]) == 0: 0 else: -1)
        else:
            discard 1

    case h[1] - t[1]:
        of 2:
            t[1] += 1
            t[0] += (if (h[0] - t[0]) > 0: 1 elif (h[0] - t[0]) == 0: 0 else: -1)
        of -2:
            t[1] -= 1
            t[0] += (if (h[0] - t[0]) > 0: 1 elif (h[0] - t[0]) == 0: 0 else: -1)
        else:
            discard 1

    return (h, t)

proc move(direction: Direction): void=
    case direction:
        of Direction.U:
            knots[0][0] += 1
        of Direction.D:
            knots[0][0] -= 1
        of Direction.L:
            knots[0][1] += 1
        of Direction.R:
            knots[0][1] -= 1
    
    for i in 0..knots.len()-2:
            let (newHead, newTail) = updateTail(knots[i], knots[i+1])
            knots[i] = newHead
            knots[i + 1] = newTail
    history.add(knots)
    tailPositions.add(knots[knots.len() - 1])

while not endOfFile(f):
    let line = f.readLine()
    let parts = line.split(" ")
    let dir = parseEnum[Direction](parts[0])
    let count = parseInt(parts[1])
    echo dir, " ", count
    for i in 0..count-1:
        move(dir)


echo tailPositions.deduplicate().len()

let minX = min(history.mapIt(min(it.mapIt(it[0]))))
let minY = min(history.mapIt(min(it.mapIt(it[1]))))

let maxX = max(history.mapIt(max(it.mapIt(it[0]))))
let maxY = max(history.mapIt(max(it.mapIt(it[1]))))

let sizeX = maxX - minX + 1
let sizeY = maxY - minY + 1


for frameIdx, frame in history:
    if not debug: break
    eraseScreen(stdout)
    var canvas = newSeqWith(sizeY, newSeqWith(sizeX, "."))

    for knotIdx, knot in tailPositions:
        if knotIdx > frameIdx: break
        canvas[knot[1] - minY][knot[0] - minX] = "*"

    for i, knot in frame:
        canvas[knot[1] - minY][knot[0] - minX] = i.intToStr()
    

    for row in canvas:
        echo row.join(" ")
    echo "Press enter to continue"
    discard readLine(stdin)
