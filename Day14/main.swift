import Foundation

let input = "nbysizxe"

extension String {
    func padLeft (totalWidth: Int, with: String) -> String {
        let toPad = totalWidth - self.count
        if toPad < 1 { return self }
        return "".padding(toLength: toPad, withPad: with, startingAt: 0) + self
    }
}

struct Square {
    var x: Int
    var y: Int
}

func parseDisk(with key: String) -> [Square] {
    
    return (0..<128).map { (row) -> [Square] in
        "\(key)-\(row)"
            .knotHash()
            .map { String($0, radix: 2).padLeft(totalWidth: 8, with: "0") }
            .joined()
            .enumerated()
            .filter { $0.element == "1" }
            .map { Square(x: $0.offset, y: row) }
        }
        .flatMap { $0 }
}

let squares = parseDisk(with: input)
print ("Part one: \(squares.count)")

// MARK: part two
extension Square: Equatable, Hashable {
    var hashValue: Int {
        return (x*1000 + y).hashValue
    }
    
    static func ==(lhs: Square, rhs: Square) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    var neighbours: [Square] {
        return [
            Square(x: x+1, y: y),
            Square(x: x,   y: y+1),
            Square(x: x-1, y: y),
            Square(x: x,   y: y-1)
        ]
    }
}

func findGroup(for square: Square, in squares: Set<Square>) -> Set<Square> {
    
    let neighbours = square
        .neighbours
        .filter { squares.contains($0) }
    
    
    var remaining = squares
    remaining.remove(square)
    for square in neighbours {
        remaining.remove(square)
    }

    var group = Set<Square>(neighbours)
    group.insert(square)
    neighbours.forEach {
        let neighbourGroup = findGroup(for: $0, in: remaining)
        for square in neighbourGroup {
            remaining.remove(square)
            group.insert(square)
        }
    }
    return group
}

var partTwoAllSquares = Set(squares) // From part one
var groups = Set<Set<Square>>()
repeat {
    let group = findGroup(for: partTwoAllSquares.first!, in: partTwoAllSquares)
    for square in group {
        partTwoAllSquares.remove(square)
    }
    groups.insert(group)
} while !partTwoAllSquares.isEmpty

print ("Part two: \(groups.count)")
