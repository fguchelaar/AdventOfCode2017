import Foundation

let input = try! String(contentsOfFile: "day7-input.txt")
let rows = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)

extension String {
    
    func substring(with range: NSRange) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: range.length)
        return String(self[startIndex..<endIndex])
    }
}

class Program {
    var name: String = ""
    var weight: Int = -1
    var children: [String] = [String]()
    
    init(with string: String) {
        let regex = try! NSRegularExpression(pattern: "(?<name>\\w+)\\s\\((?<weight>\\d+)\\)(\\s->\\s)?(?<children>.*)?$", options: .caseInsensitive )
        
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        for match in matches {
            name = string.substring(with: match.range(withName: "name"))
            weight = Int(string.substring(with: match.range(withName: "weight")))!
            children = string.substring(with: match.range(withName: "children")).components(separatedBy: ", ").filter { !$0.isEmpty }
        }
    }
    
    
}

let programs = rows.map { Program(with: $0) }

// We can discard all leafes for Part one
let programsWithChildren = programs.filter { !$0.children.isEmpty }

var root = programsWithChildren.first!
while true {
    // find the program which holds `current` as child
    let parent = programsWithChildren.first { $0.children.contains(root.name) }
    
    if parent != nil {
        root = parent!
    }
    else {
        break
    }
}

print("Part one: \(root)")


// Use the outcome of part one for part two
func getProgram(with name: String) -> Program {
    return programs.first { $0.name == name }!
}

func totalWeight(for program: Program) -> Int {
    
    let weight = program.children.reduce(0, { (sum, name) -> Int in
        return sum + totalWeight(for: getProgram(with: name))
    })
    
    return weight + program.weight
}

func traverse(root: Program) {

    let weights = root.children.map {
        totalWeight(for: getProgram(with: $0))
    }
    
    print("\(root.name) - \(root.weight)")
    let zipped = zip(root.children, weights)
    for item in zipped {
        print("\t\(item.0): \(item.1)")
    }

}
// gjxqx
// yruivis
// sphbbz

traverse(root: getProgram(with: "sphbbz"))
