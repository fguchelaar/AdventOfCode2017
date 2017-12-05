import Foundation

let input = try! String(contentsOfFile: "day5-input.txt")

var instructions = input
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .newlines)
    .map { Int($0)! }

func calculateSteps (ins: [Int], isPartTwo: Bool) -> Int {
    var mutableInstructions = ins
    
    var index = 0,
        steps = 0
    
    while index >= 0 && index < mutableInstructions.count {
        let jump = mutableInstructions[index]
        
        if isPartTwo && jump >= 3 {
            mutableInstructions[index] -= 1
        }
        else {
            mutableInstructions[index] += 1
        }
        index += jump
        steps += 1
    }
    return steps
}

print ("Part one: \(calculateSteps(ins: instructions, isPartTwo: false))")
print ("Part two: \(calculateSteps(ins: instructions, isPartTwo: true))")

