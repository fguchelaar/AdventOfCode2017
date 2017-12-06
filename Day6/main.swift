import Foundation

let input = "10\t3\t15\t10\t5\t15\t5\t15\t9\t2\t5\t8\t5\t2\t3\t6"

let banks = input.components(separatedBy: "\t").map { Int($0)! }

func redistribute(_ banks: [Int], at position: Int) -> [Int] {
    var new = banks
    let blocksToRedistribute = banks[position]
    new[position] = 0
    for i in (position+1)...(position+blocksToRedistribute) {
        new[i%new.count] += 1
    }
    return new
}

var previousStates = [String]()
var current = banks
var cycles = 0
while !previousStates.contains("\(current)") {
    previousStates.append("\(current)")
    let mostBlocks = current.enumerated().max {
        $0.element < $1.element || $0.offset > $1.offset
    }!.offset
    current = redistribute(current, at: mostBlocks)
    cycles += 1
}

print ("Part one: \(cycles)")

let previous = previousStates.index(of: "\(current)")!
print ("Part two: \(cycles - previous)")
