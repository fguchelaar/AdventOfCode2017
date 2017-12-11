import Foundation

let input = try! String(contentsOfFile: "day9-input.txt").trimmingCharacters(in: .whitespacesAndNewlines)

struct State {
    var score: Int
    var depth: Int
    var isGarbage: Bool
    var ignoreNext: Bool
    
    var garbageCount: Int
}

func calculateScore(stream: String) -> State {
    
    let s = stream.reduce(State(score: 0, depth: 1, isGarbage: false, ignoreNext: false, garbageCount: 0)) { (state, char) -> State in
    
        if state.ignoreNext {
            return State(score: state.score, depth: state.depth, isGarbage: state.isGarbage, ignoreNext: false, garbageCount: state.garbageCount)
        }
        else if char == "!" {
            return State(score: state.score, depth: state.depth, isGarbage: state.isGarbage, ignoreNext: true, garbageCount: state.garbageCount)
        }
        else if state.isGarbage && char == ">" {
            return State(score: state.score, depth: state.depth, isGarbage: false, ignoreNext: false, garbageCount: state.garbageCount)
        }
        else if state.isGarbage {
            return State(score: state.score, depth: state.depth, isGarbage: state.isGarbage, ignoreNext: false, garbageCount: state.garbageCount + 1)
        }
        
        switch char {
        case "<":
            return State(score: state.score, depth: state.depth, isGarbage: true, ignoreNext: false, garbageCount: state.garbageCount)
        case "{":
            return State(score: state.score + state.depth, depth: state.depth + 1, isGarbage: false, ignoreNext: false, garbageCount: state.garbageCount)
        case "}":
            return State(score: state.score, depth: state.depth - 1, isGarbage: false, ignoreNext: false, garbageCount: state.garbageCount)
        default:
            return state
        }
    }
    return s
}

print ("Part one: \(calculateScore(stream: input).score)")
print ("Part two: \(calculateScore(stream: input).garbageCount)")
