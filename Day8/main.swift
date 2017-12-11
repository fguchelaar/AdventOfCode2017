import Foundation

let input = try! String(contentsOfFile: "day8-input.txt")
let instructions = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)

var registers = [String: Int]()
var highestValue = 0
for instruction in instructions {
    let parts = instruction.components(separatedBy: " ")
    
    var shouldExecute = false
    switch parts[5] {
    case ">":
        shouldExecute = (registers[parts[4]] ?? 0) > Int(parts[6])!
    case "<":
        shouldExecute = (registers[parts[4]] ?? 0) < Int(parts[6])!
    case ">=":
        shouldExecute = (registers[parts[4]] ?? 0) >= Int(parts[6])!
    case "<=":
        shouldExecute = (registers[parts[4]] ?? 0) <= Int(parts[6])!
    case "==":
        shouldExecute = (registers[parts[4]] ?? 0) == Int(parts[6])!
    case "!=":
        shouldExecute = (registers[parts[4]] ?? 0) != Int(parts[6])!
    default:
        print("illegal operator: \(parts[5])")
    }
    
    if shouldExecute {
        if parts[1] == "inc" {
            registers[parts[0]] = (registers[parts[0]] ?? 0) + Int(parts[2])!
        }
        else {
            registers[parts[0]] = (registers[parts[0]] ?? 0) - Int(parts[2])!
        }
    }
    
    // For part two
    highestValue = max(registers.values.map { $0 }.max()!, highestValue)
}

let maxValue = registers.values.map { $0 }.max()!

print ("Part one: \(maxValue)")
print ("Part two: \(highestValue)")

