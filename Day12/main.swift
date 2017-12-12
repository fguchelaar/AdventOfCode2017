import Foundation

let input = try! String(contentsOfFile: "day12-input.txt").trimmingCharacters(in: .whitespacesAndNewlines)
let pipes = input.components(separatedBy: .newlines)

func addChildPipes(from pipe: String, to set: Set<Int>) -> Set<Int> {
    
    let separators = CharacterSet(charactersIn: " <->,")
    let components = pipe
        .components(separatedBy: separators).filter { !$0.isEmpty }
        .map { Int($0)! }

    var newSet = set
    
    if !newSet.contains(components.first!) {
        newSet.insert(components.first!)
    }
    
    for program in components.suffix(from: 1) {
        if !newSet.contains(program) {
            newSet = addChildPipes(from: pipes[program], to: newSet)
        }
    }
    
    return newSet
}

let program0 = addChildPipes(from: pipes[0], to: Set<Int>())
print("Part one: \(program0.count)")

// MARK: part two: brute force
var groups = Set<Set<Int>>()
for pipe in pipes {
    groups.insert(addChildPipes(from: pipe, to: Set<Int>()))
}
print("Part two: \(groups.count)")
