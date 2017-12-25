import Foundation

let input = try! String(contentsOfFile: "day24-input.txt").trimmingCharacters(in: .whitespacesAndNewlines)
//let input = """
//0/2
//2/2
//2/3
//3/4
//3/5
//0/1
//10/1
//9/10
//"""

let lines = input.components(separatedBy: .newlines)

typealias Component = (Int, Int)

func end(start: Int, component: Component) -> Int {
    if component.0 == start {
        return component.1
    }
    else {
        return component.0
    }
}

let components : [Component] = lines
    .map {
        let parts = $0.components(separatedBy: "/")
        return Component(Int(parts[0])!, Int(parts[1])!)
    }

func findCmponents(with value: Int, in list: [Component]) -> [Component] {
    return list.filter{ $0.0 == value || $0.1 == value }
}

let startingPoints = findCmponents(with: 0, in: components)


var maxScore = 0
var longestBridge = 0

func buildBridge(from start: Component, next value: Int, using: [Component], sofar: Int, length: Int) {
    
    // remove `start` from list to use
    let todo = using.filter { $0 != start }
    
    let currentScore = start.0 + start.1
    let subtotal = sofar + currentScore
    
    if length >= longestBridge {
        maxScore = max(maxScore, subtotal)
        longestBridge = length
    }
    
    let next = findCmponents(with: value, in: todo)
    
    for s in next {
        buildBridge(from: s, next: end(start: value, component: s), using: todo, sofar: subtotal, length: length + 1)
    }
}

for s in startingPoints {
    maxScore = 0
    buildBridge(from: s, next: end(start: 0, component: s), using: components, sofar: 0, length: 0)
    print (maxScore)
}
