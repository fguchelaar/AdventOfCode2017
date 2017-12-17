import Foundation

let input = 386

var buffer = [0]
var currentPosition = 0
for i in 1...2017 {
    currentPosition = ((currentPosition + input) % i) + 1
    buffer.insert(i, at: currentPosition)
}

let pos2017: Int = buffer.index(of: 2017)!

print("Part one: \(buffer[(pos2017 + 1) % buffer.count])")

// MARK: Part two, calculate all insert-postions, find highest with `1`
var valueAfter0 = -1
var insertPosition = 0
for i in 1...50000000 {
    insertPosition = (insertPosition + input) % i
    if insertPosition == 0 {
        valueAfter0 = i
    }
    insertPosition += 1
}
print("Part two: \(valueAfter0)")
