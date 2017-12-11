import Foundation

//Part one: 48705

// MARK: changed code for part two
//let input = "1,2,3"
let input = "192,69,168,160,78,1,166,28,0,83,198,2,254,255,41,12"
    .map { Int($0.unicodeScalars.filter({ $0.isASCII }).first!.value) }
    + [17, 31, 73, 47, 23]

var list = Array(0...255)
var skipSize = 0
var currentPosition = 0

for _ in 0..<64 {
    for length in input {
        
        var endIndex = currentPosition+length - 1
        for p in currentPosition..<(currentPosition+length / 2) {
            let t = list[p % list.count]
            list[p % list.count] = list[endIndex % list.count]
            list[endIndex % list.count] = t
            endIndex -= 1
        }
        
        currentPosition += length + skipSize
        skipSize += 1
    }
}

let sparseHash = list
var denseHash = [Int]()

for i in 0..<16 {
    
    let start = i*16
    let range = sparseHash[start..<start+16]
    
    let number = range.reduce(0) { $0 ^ $1 }
    denseHash.append(number)
}

let hash = denseHash.map { String(format:"%02x", $0) }.joined()

print("Part two: \(hash)")


