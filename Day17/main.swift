import Foundation

let input = 386

var buffer = [0]
var currentPosition = 0
for i in 1...2017 {
    currentPosition = ((currentPosition + input) % buffer.count) + 1
    buffer.insert(i, at: currentPosition)
}

let pos2017: Int = buffer.index(of: 2017)!

print("Part one: \(buffer[(pos2017 + 1) % buffer.count])")

// MARK: Part two, calculate all insert-postions, find highest with `1`
var insertPositions = [0]
for i in 1...50000000 {
    insertPositions.append(((insertPositions[i-1] + input) % i) + 1)
}

for i in stride(from: insertPositions.count-1, to: 0, by: -1) {
    if insertPositions[i] == 1 {
        print("Part two: \(i)")
        break
    }
}
