import std/strutils
import std/algorithm
import std/strformat
import std/sequtils

type
 File = ref object
  name*: string
  size*: int
  parent*: Directory

 Directory = ref object
  name*: string
  files*: seq[File]
  directories*: seq[Directory]
  parent*: Directory
  size*: int

let f = open("./input.txt")

var rootDir = Directory(name: "/", files: @[], directories: @[])
var cwd = rootDir

var reading = false

while not endOfFile(f):
 let line = f.readLine()
 let lineParts = line.split(" ")


 if lineParts[0] == "$":
  reading = false
  # ls command
  if lineParts[1] == "ls":
   reading = true
   continue
  if lineParts[1] == "cd":
   let dest = lineParts[2]
   let targets = cwd.directories.filterIt(it.name == dest)

   if dest == "/":
    cwd = rootDir
   elif dest == "..":
    cwd = cwd.parent
   else:
    assert targets.len() == 1
    cwd = targets[0]
   continue

 if reading:
  let parts = line.split(" ")
  if parts[0] == "dir":
   cwd.directories.add(Directory(name: parts[1], files: @[], directories: @[], parent: cwd))
   continue
  else:
   cwd.files.add(File(name: parts[1], size: parseInt(parts[0]), parent: cwd))
   continue

proc buildDirectorySizes(d: Directory): int =
 var size = 0
 for file in d.files:
  size = size + file.size
 for directory in d.directories:
  size = size + buildDirectorySizes(directory)
 d.size = size
 return size

discard buildDirectorySizes(rootDir)

proc buildPartOne(d: Directory, threshold: int): int =
 var output = 0
 if d.size <= threshold or threshold < 0:
  output = output + d.size
 for dir in d.directories:
  output = output + buildPartOne(dir, threshold)
 return output

echo fmt"Part 1: {buildPartOne(rootDir, 100000)}"

proc treeToArray(d: Directory): seq[Directory] =
 var output = @[d]
 for dir in d.directories:
  output = output & treeToArray(dir)
 return output

proc dirCmp(x, y: Directory): int =
 return cmp(x.size, y.size)

const driveCapacity = 70000000
let usedSpace = rootDir.size
let availableSpace = driveCapacity - usedSpace

var allDirs = treeToArray(rootDir)
allDirs.sort(dirCmp, Descending)

echo fmt"Part 2: {min(allDirs.filterIt(availableSpace + it.size >= 30000000).mapIt(it.size))}"
