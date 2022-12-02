import std/strutils
import std/enumutils

let f = open("./input.txt")

type Move = enum
    THEM_ROCK = "A", THEM_PAPER = "B", THEM_SCISSORS = "C"
type Reply = enum
    ME_ROCK   = "X", ME_PAPER   = "Y", ME_SCISSORS   = "Z"

type IntendedOutcome = enum
    LOSE   = "X", DRAW   = "Y", WIN   = "Z"

var lookup = [
    [2,0,1],
    [0,1,2],
    [1,2,0],
]


var line: string
var myTotalScore = 0
echo "|----------------|"
echo "| Rounds         |"
while not endOfFile(f):

    line = f.readLine()
    if line == "": continue
    
    echo "|----------------|"
    let split = line.split(" ")
    let theirPlay = parseEnum[Move](split[0])
    let theirValue = ord(theirPlay)
    
    
    let outcome = parseEnum[IntendedOutcome](split[1])
    let myValue = lookup[ord(outcome)][theirValue]
    let myPlay = Reply(myValue)

    let diff = myValue - theirValue
    echo "| Me: ", align(myPlay.symbolName.split("_")[1], 10), " |"
    echo "| Them: ", align(theirPlay.symbolName.split("_")[1], 8), " |"
    echo "| Should: ", align(outcome.symbolName, 6), " |"

    var myScore = myValue + 1

    if diff == 0:
        echo "| Result:   Tie! |"
        myScore = myScore + 3
    elif diff == 1 or diff == -2:
        echo "| Result:   Win! |"
        myScore = myScore + 6
    elif diff == -1 or diff == 2:
        echo "| Result:  Lose! |"
        myScore = myScore + 0

    myTotalScore = myTotalScore + myScore

echo "|----------------|"
echo "| Score: " , align(myTotalScore.intToStr(), 7), " |"
echo "|----------------|"
