import Foundation

let input = try! String(contentsOfFile: "day16-input.txt").trimmingCharacters(in: .whitespacesAndNewlines)
let moves = input.components(separatedBy: ",")

let danceLine = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p"]

func spin(x: Int, in line: [String]) -> [String] {
    return Array(line.suffix(x)) + Array(line.prefix(upTo: line.count - x))
}

func exchange(a: Int, b: Int, in line: [String]) -> [String] {
    var temp = line
    temp.swapAt(a, b)
    return temp
}

func partner(a: String, b: String, in line: [String]) -> [String] {
    let aPos: Int = line.index(of: a)!
    let bPos: Int = line.index(of: b)!
    var temp = line
    temp.swapAt(aPos, bPos)
    return temp
}


// Change range to `1` for part one, `1000000000` for part two
// My *magic number* appears to be `42`. Did a `print` for the first 100 cycles
// and manually looked it up
measure {
    var endPosition = danceLine
    for i in 0..<1000000000 % 42 {
        endPosition = moves.reduce(endPosition) {
            switch $1.first! {
            case "s":
                let x = Int($1.dropFirst())!
                return spin(x: x, in: $0)
            case "x":
                let ab = $1.dropFirst().components(separatedBy: "/")
                let a = Int(ab[0])!
                let b = Int(ab[1])!
                return exchange(a: a, b: b, in: $0)
            case "p":
                let ab = $1.dropFirst().components(separatedBy: "/")
                let a = ab[0]
                let b = ab[1]
                return partner(a: a, b: b, in: $0)
            default:
                print("invalid input: \($1)")
                return $0
            }
        }
    }
    
    print ("\(endPosition.joined())")
}
