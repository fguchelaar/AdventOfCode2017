import Foundation

let input = try! String(contentsOfFile: "day22-input.txt").trimmingCharacters(in: .whitespacesAndNewlines)

//let input = """
//..#
//#..
//...
//"""

struct Position: Hashable {
    var x: Int
    var y: Int
    
    var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
    
    static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

class VirusCarrier {
    enum Direction: Int {
        case up = 0
        case right
        case down
        case left
        
        func turnLeft() -> Direction {
            return Direction(rawValue: (self.rawValue - 1 + 4) % 4)!
        }
        
        func turnRight() -> Direction {
            return Direction(rawValue: (self.rawValue + 1) % 4)!
        }
        
        func reverse() -> Direction {
            return Direction(rawValue: (self.rawValue + 2) % 4)!
        }
        
        var vector: (dx: Int, dy: Int) {
            switch self {
            case .up:
                return (0, -1)
            case .right:
                return (1, 0)
            case .down:
                return (0, 1)
            case .left:
                return (-1, 0)
            }
        }
    }
    
    var infected: [Position: Int]
    var position: Position
    var direction = Direction.up
    var numberOfInfections = 0
    
    init(infected: [Position: Int], startPosition: Position) {
        self.infected = infected
        self.position = startPosition
    }
    
    func burst() {
        if infected.keys.contains(position) {
            direction = direction.turnRight()
            infected.removeValue(forKey: position)
        }
        else {
            direction = direction.turnLeft()
            infected[position] = 2
            numberOfInfections += 1
        }
        position.x += direction.vector.dx
        position.y += direction.vector.dy
    }
    
    func burst2() {
        if infected[position, default: 0] == 0 { // 0==clean
            direction = direction.turnLeft()
        }
        else if infected[position, default: 0] == 1 { // 1==Weakened
            numberOfInfections += 1
        }
        else if infected[position, default: 0] == 2 { // 2==Infected
            direction = direction.turnRight()
        }
        else { // 3==Flagged
            direction = direction.reverse()
        }
        
        infected[position] = (infected[position, default: 0] + 1) % 4
        position.x += direction.vector.dx
        position.y += direction.vector.dy
    }
}

// Parse input to Position values for each infected position
let lines = input
    .components(separatedBy: .newlines)

let initial = lines
    .enumerated()
    .reduce(into: [Position: Int]()) { (dict, line) in
        line.element
            .enumerated()
            .filter { $0.element == "#" }
            .map { Position(x: $0.offset, y:line.offset) }
            .forEach { dict[$0] = 2 } // infected gets value 2, so we can insert other states later (weakened becomes 1)
}

let x = lines.count / 2
let y = lines.count / 2

measure {
    let carrier = VirusCarrier(infected: initial, startPosition: Position(x: x, y: y))
    let numberOfBursts = 10000
    for _ in 0..<numberOfBursts {
        carrier.burst()
    }
    print("Part one: \(carrier.numberOfInfections)")
}

measure {
    let carrier2 = VirusCarrier(infected: initial, startPosition: Position(x: x, y: y))
    let numberOfBursts2 = 10000000
    for _ in 0..<numberOfBursts2 {
        carrier2.burst2()
    }
    print("Part two: \(carrier2.numberOfInfections)")
}
